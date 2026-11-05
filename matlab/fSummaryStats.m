function mStats = fSummaryStats(mData)
% fSummaryStats  Mean, standard deviation, 5th percentile, median,
% 95th percentile, minimum, and maximum of each column.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

mStats = [mean(mData); std(mData); fQuantile(mData, 0.05); ...
          fQuantile(mData, 0.50); fQuantile(mData, 0.95); ...
          min(mData); max(mData)];
end
