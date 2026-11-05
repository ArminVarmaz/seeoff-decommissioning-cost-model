function vQ = fQuantile(mData, dP)
% fQuantile  Quantile dP of each column, linear interpolation between
% the sorted values at the positions (k - 0.5) / n.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

iNum   = size(mData, 1);
mSort  = sort(mData, 1);
dPos   = min(max(dP * iNum + 0.5, 1), iNum);
iLow   = floor(dPos);
iHigh  = min(iLow + 1, iNum);
dW     = dPos - iLow;
vQ     = (1 - dW) * mSort(iLow, :) + dW * mSort(iHigh, :);
end
