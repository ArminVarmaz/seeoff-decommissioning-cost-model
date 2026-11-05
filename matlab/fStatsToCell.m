function cTable = fStatsToCell(mStats, cNames, sTitle)
% fStatsToCell  Labeled table of fSummaryStats, one row per scenario.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cLabels = {'Mean', 'Std', 'P5', 'Median', 'P95', 'Min', 'Max'};
cTable  = [[{sTitle}, cLabels]; [cNames(:), num2cell(mStats')]];
end
