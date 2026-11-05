% b6_Results.m
% Summary tables in the format of Tables 3 and 5 of the paper, a boxplot,
% and the result files.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cScen = rData.rAlloc.cScenarios;

% Net costs per MW in thousand euro (Table 3)
mStatsMW = fSummaryStats(rData.rScenario.mNetPerMW / 1000);
cTableMW = fStatsToCell(mStatsMW, cScen, 'Net cost per MW (kEUR)');
disp(cTableMW);

% Onshore costs, revenues, and shortfall probability per location (Table 5)
mOnshoreLoc = rData.rScenario.mOnshore / rSettings.iNumTurbines / 1000;
mRevenueLoc = rData.rScenario.mRevenue / rSettings.iNumTurbines / 1000;
vShortfall  = fShortfallProbability(rData.rScenario.mOnshore, rData.rScenario.mRevenue);
cTableShortfall = [{'kEUR per location'}, cScen; ...
    {'Onshore cost mean'}, num2cell(mean(mOnshoreLoc)); ...
    {'Revenue mean'},      num2cell(mean(mRevenueLoc)); ...
    {'P(onshore > revenue) %'}, num2cell(100 * vShortfall)];
disp(cTableShortfall);

% Diagnostics of the correlation correction and the rejection step
cTableDiag = fDiagnosticsToCell(rData);
disp(cTableDiag);

% Figure 3 of the paper
fPlotBoxplot(rData.rScenario.mNetPerMW / 1e6, cScen, ...
    'Net decommissioning costs per MW', 'Net costs per MW in million EUR');

% Result files
if ~exist(rSettings.sFolderResults, 'dir'), mkdir(rSettings.sFolderResults); end
sFileXls = fullfile(rSettings.sFolderResults, 'Results.xlsx');
fWriteSheet(cTableMW,        sFileXls, 'NetCostPerMW');
fWriteSheet(cTableShortfall, sFileXls, 'Shortfall');
fWriteSheet(cTableDiag,      sFileXls, 'Diagnostics');
saveas(gcf, fullfile(rSettings.sFolderResults, 'Boxplot_NetCostPerMW.png'));
if fIsOctave()
    save('-binary', fullfile(rSettings.sFolderResults, 'rData.mat'), 'rData');
else
    save(fullfile(rSettings.sFolderResults, 'rData.mat'), 'rData', '-v7.3');
end
fprintf('Results written to %s\n', rSettings.sFolderResults);
