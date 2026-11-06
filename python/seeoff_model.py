"""Simplified SeeOff decommissioning cost model (Python version).

Python translation of the MATLAB reference implementation in ../matlab.
The MATLAB code is the benchmark. Both versions use the same algorithm and
give the same results up to Monte Carlo noise; the random numbers differ.

Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
for offshore wind farm decommissioning: A scenario analysis for the
German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

Copyright (c) 2026 Armin Varmaz, Hochschule Bremen.
License: CC BY-NC 4.0, see LICENSE.

Usage: python seeoff_model.py [path/to/input.xlsx]
"""
import re
import sys
from pathlib import Path

import numpy as np
import pandas as pd
from scipy.special import ndtr, ndtri

HERE = Path(__file__).resolve().parent

# Settings (same meaning as in b0_Main.m)
SETTINGS = {
    "file_input": HERE.parent / "data" / "InputSynthetic.xlsx",
    "folder_results": HERE.parent / "results",
    "num_simulations": 100_000,   # valid draws per block
    "oversampling": 1.4,          # draws generated per valid draw
    "seed": 20261105,             # seed of the random number generator
    "num_turbines": 80,           # number of foundation locations
    "turbine_mw": 3.6,            # rated power per turbine in MW
    "baseline": "BS",             # name of the baseline scenario
    "independence": False,        # True: all correlations set to zero
    "stop_rule": "paper",         # 'paper' or 'converge', see correct_correlation
}


# ---------------------------------------------------------------- reading
def valid_name(label):
    """Turns a label into a comparable name, e.g. '1.1.A' -> 'x1_1_A'."""
    text = re.sub(r"\W", "_", to_str(label))
    return text if text[:1].isalpha() else "x" + text


def to_str(value):
    """Cell value as text. Whole numbers lose their decimals, empty cells become ''."""
    if value is None or (isinstance(value, float) and np.isnan(value)):
        return ""
    if isinstance(value, float) and value.is_integer():
        return str(int(value))
    return str(value).strip()


def read_sheet(file, sheet):
    """One sheet with the first row as header."""
    return pd.read_excel(file, sheet_name=sheet, dtype=object)


def read_cost_rates(file):
    """Sheet 'Resources': one row per cost element of a resource."""
    df = read_sheet(file, "Resources")
    df = df[df["Resource"].map(to_str) != ""]
    cost = {
        "resource": [valid_name(x) for x in df["Resource"]],
        "element": [to_str(x) for x in df["CostElement"]],
        "factor": [to_str(x) for x in df["sFactor"]],
        "dist": [to_str(x) for x in df["sDistribution"]],
        "par": df[["dParameterA", "dParameterB", "dParameterC"]].astype(float).to_numpy(),
    }
    cost["labels"] = [valid_name(f"{r}_{e}") for r, e in zip(cost["resource"], cost["element"])]
    return cost


def read_allocation(file):
    """Units of each resource per process, and processes per scenario."""
    df = read_sheet(file, "ProcessResources")
    df = df[df.iloc[:, 0].map(to_str) != ""]
    proc_cols = [c for c in df.columns[1:] if not str(c).startswith("Unnamed")]
    alloc = {
        "processes": [valid_name(c) for c in proc_cols],
        "resources": [valid_name(x) for x in df.iloc[:, 0]],
        "units": df[proc_cols].fillna(0).astype(float).to_numpy(),   # resources x processes
    }
    alloc["group"] = np.array([int(re.search(r"\d", p).group()) for p in alloc["processes"]])

    df = read_sheet(file, "ScenarioProcesses")
    df = df[df.iloc[:, 0].map(to_str) != ""]
    scen_cols = [c for c in df.columns[1:] if not str(c).startswith("Unnamed")]
    rows = [valid_name(x) for x in df.iloc[:, 0]]
    order = match_order(rows, alloc["processes"])
    alloc["scenarios"] = [str(c) for c in scen_cols]
    alloc["in_scenario"] = df[scen_cols].astype(float).to_numpy()[order, :] == 1   # processes x scenarios
    return alloc


def read_specifications(file):
    """Sheet 'ProcessSpecifications': durations and quantities of each process."""
    df = read_sheet(file, "ProcessSpecifications")
    df = df[df["Process"].map(to_str) != ""]
    spec = {
        "process": [valid_name(x) for x in df["Process"]],
        "name": [to_str(x) for x in df["Specification"]],
        "dist": [to_str(x) for x in df["sDistribution"]],
        "par": df[["dParameterA", "dParameterB", "dParameterC"]].astype(float).to_numpy(),
    }
    spec["labels"] = [valid_name(f"{p}_{n}") for p, n in zip(spec["process"], spec["name"])]
    return spec


def read_correlation(file, sheet, labels):
    """Lower triangle from the workbook, mirrored, in the order of labels."""
    raw = pd.read_excel(file, sheet_name=sheet, header=None, dtype=object)
    names = [to_str(x) for x in raw.iloc[1:, 0]]
    keep = [i for i, n in enumerate(names) if n]
    n = len(keep)
    lower = raw.iloc[[1 + i for i in keep], 1:n + 1].astype(float).fillna(0).to_numpy()
    corr = np.tril(lower, -1) + np.tril(lower, -1).T + np.eye(n)
    order = match_order([valid_name(names[i]) for i in keep], labels)
    return corr[np.ix_(order, order)]


def match_order(source, target):
    """Index list with source[idx] equal to target."""
    pos = {name: i for i, name in enumerate(source)}
    missing = [t for t in target if t not in pos]
    if missing:
        raise KeyError(f"Labels not found: {missing[:5]}")
    return [pos[t] for t in target]


def cost_map(cost, alloc, spec):
    """Rows [process, cost rate, specification or -1, units]: cost = units x rate x spec."""
    spec_pos = {(p, n): i for i, (p, n) in enumerate(zip(spec["process"], spec["name"]))}
    rows = []
    for j, proc in enumerate(alloc["processes"]):
        for r in np.flatnonzero(alloc["units"][:, j] > 0):
            units = alloc["units"][r, j]
            for k in [k for k, res in enumerate(cost["resource"]) if res == alloc["resources"][r]]:
                factor = cost["factor"][k]
                if factor == "1":
                    s = -1
                elif (proc, factor) in spec_pos:
                    s = spec_pos[(proc, factor)]
                else:
                    raise KeyError(f"Specification {factor} of process {proc} not found.")
                rows.append((j, k, s, units))
    return np.array(rows, dtype=float)


# ------------------------------------------------------ correlation matrices
def input_std(dist, par):
    """Standard deviation of each input. Normal: B. Triangular: closed form."""
    std = np.empty(len(dist))
    for i, d in enumerate(dist):
        a, b, c = par[i]
        if d.lower() == "normal":
            std[i] = b
        elif d.lower() == "triangular":
            std[i] = np.sqrt((a * a + b * b + c * c - a * b - a * c - b * c) / 18)
        else:
            raise ValueError(f"Unknown distribution {d}.")
    return std


def project_psd(m):
    """Nearest positive semidefinite matrix: negative eigenvalues set to zero."""
    m = (m + m.T) / 2
    w, v = np.linalg.eigh(m)
    out = (v * np.maximum(w, 0)) @ v.T
    return (out + out.T) / 2


def nearest_corr(corr, tol, max_iter=1000, eig_tol=1e-10):
    """Alternating projections of Higham (2002) with Dykstra's correction,
    then shrinkage toward the identity so that the smallest eigenvalue is
    at least eig_tol."""
    n = corr.shape[0]
    y = (corr + corr.T) / 2
    delta = np.zeros((n, n))
    for it in range(1, max_iter + 1):
        r = y - delta
        x = project_psd(r)
        delta = x - r
        y_old = y
        y = x.copy()
        np.fill_diagonal(y, 1)
        if np.linalg.norm(y - y_old, "fro") < tol:
            break
    y = (y + y.T) / 2
    lam = np.linalg.eigvalsh(y).min()
    shrink = max(0.0, (eig_tol - lam) / (1 - lam))
    new = (1 - shrink) * y + shrink * np.eye(n)
    new = (new + new.T) / 2
    np.fill_diagonal(new, 1)
    return new, {"iterations": it, "shrinkage": shrink}


def correct_correlation(corr, dist, par, stop_rule):
    """Unchanged if valid, else nearest_corr. 'paper': stop once the change is
    smaller than the smallest input standard deviation (3 and 10 iterations in
    the paper). 'converge': tolerance 1e-8."""
    eig_tol = 1e-10
    info = {"lambda_min_specified": np.linalg.eigvalsh((corr + corr.T) / 2).min()}
    if info["lambda_min_specified"] >= eig_tol:
        info["corrected"] = False
        return corr, info
    tol = input_std(dist, par).min() if stop_rule == "paper" else 1e-8
    used, near = nearest_corr(corr, tol, 1000, eig_tol)
    info.update(corrected=True, **near,
                lambda_min_used=np.linalg.eigvalsh(used).min(),
                frobenius=np.linalg.norm(used - corr, "fro"),
                max_change=np.abs(used - corr).max())
    return used, info


# ---------------------------------------------------------------- simulation
def tri_inv(u, a, b, c):
    """Inverse distribution function of the triangular distribution."""
    x = c - np.sqrt((1 - u) * (c - a) * (c - b))
    left = u < (b - a) / (c - a)
    x[left] = a + np.sqrt(u[left] * (c - a) * (b - a))
    return x


def corr_random_numbers(rng, num_draws, dist, par, corr):
    """Gaussian copula: correlated standard normals, then inverse distribution functions."""
    z = rng.standard_normal((num_draws, len(dist))) @ np.linalg.cholesky(corr).T
    u = ndtr(z)
    draws = np.empty_like(u)
    for i, d in enumerate(dist):
        a, b, c = par[i]
        if d.lower() == "normal":
            draws[:, i] = a + b * ndtri(u[:, i])
        elif d.lower() == "triangular":
            draws[:, i] = tri_inv(u[:, i], a, b, c)
        else:
            raise ValueError(f"Unknown distribution {d}.")
    return draws


def valid_draws(draws, revenue):
    """No negative cost, duration, or quantity; no positive revenue rate."""
    bad = (draws[:, ~revenue] < 0).any(axis=1) | (draws[:, revenue] > 0).any(axis=1)
    return ~bad


def keep_valid(draws, valid, num_keep):
    out = draws[valid]
    if out.shape[0] < num_keep:
        raise ValueError(f"Only {out.shape[0]} valid draws. Increase oversampling.")
    return out[:num_keep]


def process_costs(cmap, draws_cost, draws_spec, num_proc):
    """Cost of each process in each run (Eq. 1)."""
    out = np.zeros((draws_cost.shape[0], num_proc))
    for j, k, s, units in cmap:
        cost = draws_cost[:, int(k)] * units
        if s >= 0:
            cost = cost * draws_spec[:, int(s)]
        out[:, int(j)] += cost
    return out


def scenario_costs(proc_cost, alloc):
    """Net, gross, onshore, and revenue totals per scenario."""
    inc = alloc["in_scenario"].astype(float)
    g = alloc["group"]
    def part(mask):
        return proc_cost[:, mask] @ inc[mask, :]
    return {"net": proc_cost @ inc, "gross": part(g <= 3),
            "onshore": part((g == 2) | (g == 3)), "revenue": part(g == 4)}


# ------------------------------------------------------------------- results
def summary_stats(data, names):
    """Mean, Std, P5, Median, P95, Min, Max per column (percentiles as in MATLAB)."""
    q = lambda p: np.percentile(data, 100 * p, axis=0, method="hazen")
    return pd.DataFrame({"Mean": data.mean(0), "Std": data.std(0, ddof=1), "P5": q(0.05),
                         "Median": q(0.5), "P95": q(0.95), "Min": data.min(0), "Max": data.max(0)},
                        index=names)


def run(settings=SETTINGS):
    s = settings
    # read (b2)
    cost = read_cost_rates(s["file_input"])
    alloc = read_allocation(s["file_input"])
    spec = read_specifications(s["file_input"])
    cost["corr"] = read_correlation(s["file_input"], "CorrelationCostRates", cost["labels"])
    spec["corr"] = read_correlation(s["file_input"], "CorrelationSpecifications", spec["labels"])
    cmap = cost_map(cost, alloc, spec)
    print(f"Input read: {len(cost['labels'])} cost rates, {len(spec['labels'])} specifications, "
          f"{len(alloc['processes'])} processes, {len(alloc['scenarios'])} scenarios.")
    # correct correlations (b3)
    for block in (cost, spec):
        if s["independence"]:
            block["corr_used"], block["info"] = np.eye(len(block["labels"])), {"corrected": False}
        else:
            block["corr_used"], block["info"] = correct_correlation(
                block["corr"], block["dist"], block["par"], s["stop_rule"])
    # random numbers (b4)
    rng = np.random.default_rng(s["seed"])
    num_draws = int(np.ceil(s["num_simulations"] * s["oversampling"]))
    raw_cost = corr_random_numbers(rng, num_draws, cost["dist"], cost["par"], cost["corr_used"])
    ok_cost = valid_draws(raw_cost, cost["par"][:, 0] < 0)
    raw_spec = corr_random_numbers(rng, num_draws, spec["dist"], spec["par"], spec["corr_used"])
    ok_spec = valid_draws(raw_spec, np.zeros(len(spec["dist"]), bool))
    draws_cost = keep_valid(raw_cost, ok_cost, s["num_simulations"])
    draws_spec = keep_valid(raw_spec, ok_spec, s["num_simulations"])
    # costs (b5)
    proc_cost = process_costs(cmap, draws_cost, draws_spec, len(alloc["processes"]))
    scen = scenario_costs(proc_cost, alloc)
    net_per_mw = scen["net"] / (s["num_turbines"] * s["turbine_mw"])
    # results (b6)
    names = alloc["scenarios"]
    table_mw = summary_stats(net_per_mw / 1000, names)
    table_shortfall = pd.DataFrame({
        "Onshore cost mean": scen["onshore"].mean(0) / s["num_turbines"] / 1000,
        "Revenue mean": scen["revenue"].mean(0) / s["num_turbines"] / 1000,
        "P(onshore > revenue) %": 100 * (scen["onshore"] > -scen["revenue"]).mean(0)}, index=names)
    table_diag = pd.DataFrame({"Cost rates": {**cost["info"], "rejected_share": 1 - ok_cost.mean()},
                               "Durations and quantities": {**spec["info"], "rejected_share": 1 - ok_spec.mean()}})
    pd.set_option("display.float_format", "{:.2f}".format)
    print("\nNet cost per MW (kEUR)\n", table_mw)
    print("\nOnshore costs and revenues per location (kEUR)\n", table_shortfall)
    print("\nDiagnostics\n", table_diag.to_string(float_format="{:.4g}".format))
    folder = Path(s["folder_results"])
    folder.mkdir(parents=True, exist_ok=True)
    with pd.ExcelWriter(folder / "Results_python.xlsx") as xls:
        table_mw.to_excel(xls, sheet_name="NetCostPerMW")
        table_shortfall.to_excel(xls, sheet_name="Shortfall")
        table_diag.to_excel(xls, sheet_name="Diagnostics")
    try:
        import matplotlib
        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        fig, ax = plt.subplots()
        ax.boxplot(net_per_mw / 1e6, showfliers=False)
        ax.set_xticks(range(1, len(names) + 1), names)
        ax.set(title="Net decommissioning costs per MW", xlabel="Scenario",
               ylabel="Net costs per MW in million EUR")
        ax.grid(True)
        fig.savefig(folder / "Boxplot_NetCostPerMW_python.png", dpi=150)
    except ImportError:
        print("matplotlib not installed: no figure.")
    return {"net_per_mw": net_per_mw, "tables": (table_mw, table_shortfall, table_diag)}


if __name__ == "__main__":
    if len(sys.argv) > 1:
        SETTINGS["file_input"] = Path(sys.argv[1])
    run()
