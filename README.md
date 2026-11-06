# SeeOff decommissioning cost model (simplified)

Simplified MATLAB implementation (with a Python translation) of the process-based
Monte Carlo cost model in

Varmaz, A. (2026). Process-based Monte Carlo cost simulation for offshore wind farm
decommissioning: A scenario analysis for the German North Sea. *Renewable Energy*.
https://doi.org/10.1016/j.renene.2026.126679

The MATLAB code is the reference implementation (benchmark). Translations to other
languages are checked against it.

## What the model does

1. Reads resources, cost rates, processes, scenarios, durations and quantities, and
   two correlation matrices from one Excel workbook.
2. Corrects each correlation matrix to a valid correlation matrix if necessary
   (alternating projections of Higham, 2002, with Dykstra's correction and a small
   shrinkage toward the identity).
3. Draws correlated inputs through a Gaussian copula: normal distributions for cost
   rates and quantities, triangular distributions for durations. Draws with a
   negative cost, duration, or quantity, or a positive revenue rate, are rejected.
4. Computes the cost of each process as units x rate x duration (or quantity), plus
   fixed amounts, and adds the processes of each scenario.
5. Reports net costs per MW (mean, standard deviation, percentiles), the probability
   that onshore costs exceed material revenues, and diagnostics of the correction
   and the rejection step.

## Data

`data/InputSynthetic.xlsx` contains a **hypothetical baseline scenario** with
**synthetic data**. It follows the baseline of the paper in a simplified form:
12 processes (removal of turbines, foundations, cables, substation, and scour
protection, port handling, onshore processing, transport, and material sale) and
19 resources. All numbers are invented round values. They are not project data, and
the results do not reproduce the paper. The project data are confidential. The sheet
`Info` describes the processes.

Sheets:

| Sheet | Content |
|---|---|
| Resources | One row per cost element of a resource: rate, distribution, and the duration or quantity it is multiplied with (`1` = fixed amount) |
| ProcessResources | Number of units of each resource (rows) used in each process (columns) |
| ScenarioProcesses | Processes (rows) contained in each scenario (columns), 0 or 1 |
| ProcessSpecifications | Durations and quantities of each process with their distributions |
| CorrelationCostRates | Correlations of the cost rates (lower triangle) |
| CorrelationSpecifications | Correlations of the durations and quantities (lower triangle) |

Parameters: normal A = mean, B = standard deviation; triangular A = minimum,
B = mode, C = maximum. Revenues are negative rates. Process codes start with the
group: 1 offshore, 2 and 3 onshore, 4 material revenues.

## How to run

**MATLAB.** Open MATLAB in the folder `matlab` and run `b0_Main`. Options are set at
the top of `b0_Main.m`. Results are written to the folder `results`. No toolbox is
needed. `readcell` and `writecell` require MATLAB R2019a or later.

**GNU Octave.** The code also runs under GNU Octave (tested with Octave 8.4). It needs
the `io` package for reading Excel files (`pkg install -forge io`). Start Octave in
the folder `matlab` and run `b0_Main`. Under Octave, the result tables are written as
CSV files instead of an Excel workbook.

**Python.** `python/seeoff_model.py` is a translation of the MATLAB code into one
file. It needs Python 3.10 or later and the packages in `python/requirements.txt`
(`pip install -r python/requirements.txt`). Run `python python/seeoff_model.py`
or pass another workbook as argument. The MATLAB code is the benchmark: both versions
use the same algorithm and give the same results up to Monte Carlo noise, because
the random number generators differ.

The code is written for clarity, not for speed. One run with 100,000 draws takes a
few seconds.

`b1_CreateCorrelations.m` (optional, MATLAB only) replaces the two correlation sheets
with new random correlation matrices from `gallery('randcorr')`.

## Code conventions

One function per file. Scripts start with `b` and a number that gives the order.
Functions start with `f`. The first letter of a variable gives its type: `d` scalar,
`i` integer, `l` logical, `v` vector, `m` matrix, `c` cell array, `s` text, `r` struct.

## License and citation

Free for non-commercial use, in particular research and teaching, under the
Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0),
see `LICENSE`. For commercial use or joint research projects, please contact
armin.varmaz@hs-bremen.de.

If you use the code, please cite the article above (see `CITATION.cff`).
