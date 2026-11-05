% b5_Calculate.m
% Cost of each process (rate times duration or quantity, summed over
% resources) and aggregation to the ten scenarios.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

rData.mProcessCost = fProcessCosts(rData.mCostMap, rData.mDrawsCost, ...
    rData.mDrawsSpec, numel(rData.rAlloc.cProcesses));
rData.rScenario = fScenarioCosts(rData.mProcessCost, rData.rAlloc);

dParkMW = rSettings.iNumTurbines * rSettings.dTurbineMW;
rData.rScenario.mNetPerMW = rData.rScenario.mNet / dParkMW;
