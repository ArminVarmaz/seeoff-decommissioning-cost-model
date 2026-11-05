function mProcessCost = fProcessCosts(mMap, mDrawsCost, mDrawsSpec, iNumProc)
% fProcessCosts  Cost of each process in each simulation run (Eq. 1):
% sum over resources and cost elements of units x rate x duration or
% quantity. Fixed amounts enter without a multiplier.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

mProcessCost = zeros(size(mDrawsCost, 1), iNumProc);
for iRow = 1:size(mMap, 1)
    iProc = mMap(iRow, 1);
    vCost = mDrawsCost(:, mMap(iRow, 2)) * mMap(iRow, 4);
    if mMap(iRow, 3) > 0
        vCost = vCost .* mDrawsSpec(:, mMap(iRow, 3));
    end
    mProcessCost(:, iProc) = mProcessCost(:, iProc) + vCost;
end
end
