function rScenario = fScenarioCosts(mProcessCost, rAlloc)
% fScenarioCosts  Adds the process costs of each scenario.
% mNet: all processes. mGross: groups 1 to 3 (expenditures).
% mOnshore: groups 2 and 3. mRevenue: group 4 (negative values).
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

lScen = double(rAlloc.lScenario);
vGroup = rAlloc.vGroup;
rScenario.mNet     = mProcessCost * lScen;
rScenario.mGross   = mProcessCost(:, vGroup <= 3) * lScen(vGroup <= 3, :);
rScenario.mOnshore = mProcessCost(:, vGroup == 2 | vGroup == 3) * ...
                     lScen(vGroup == 2 | vGroup == 3, :);
rScenario.mRevenue = mProcessCost(:, vGroup == 4) * lScen(vGroup == 4, :);
end
