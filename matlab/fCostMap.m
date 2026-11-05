function mMap = fCostMap(rData)
% fCostMap  Links every cost element to the processes that use it.
% Each row of mMap is [process, cost rate, specification, units]:
% the cost of the row is units x rate x specification. The
% specification is 0 for a fixed amount (factor '1').
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

mMap = zeros(0, 4);
for iProc = 1:numel(rData.rAlloc.cProcesses)
    vRes = find(rData.rAlloc.mUnits(:, iProc) > 0)';
    for iRes = vRes
        dUnits = rData.rAlloc.mUnits(iRes, iProc);
        vRate  = find(strcmp(rData.rCost.cResource, rData.rAlloc.cResources{iRes}))';
        for iRate = vRate
            iSpec = fFindSpec(rData.rSpec, rData.rAlloc.cProcesses{iProc}, ...
                rData.rCost.cFactor{iRate});
            mMap(end + 1, :) = [iProc, iRate, iSpec, dUnits]; %#ok<AGROW>
        end
    end
end
end

