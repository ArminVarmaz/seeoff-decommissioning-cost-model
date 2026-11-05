function vX = fTriInv(vU, dMin, dMode, dMax)
% fTriInv  Inverse distribution function of the triangular distribution.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

dRange = dMax - dMin;
dCut   = (dMode - dMin) / dRange;
vX     = dMax - sqrt((1 - vU) * dRange * (dMax - dMode));
lLeft  = vU < dCut;
vX(lLeft) = dMin + sqrt(vU(lLeft) * dRange * (dMode - dMin));
end
