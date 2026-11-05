% b2_ReadInput.m
% Reads the input workbook into the struct rData.
% Needs rSettings from b0_Main.m.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

rData = struct();
rData.rSettings  = rSettings;
rData.rCost      = fReadCostRates(rSettings.sFileInput);
rData.rAlloc     = fReadAllocation(rSettings.sFileInput);
rData.rSpec      = fReadSpecifications(rSettings.sFileInput);
rData.rCost.mCorrSpecified = fReadCorrelation(rSettings.sFileInput, ...
    'CorrelationCostRates', rData.rCost.cLabels);
rData.rSpec.mCorrSpecified = fReadCorrelation(rSettings.sFileInput, ...
    'CorrelationSpecifications', rData.rSpec.cLabels);
rData.mCostMap   = fCostMap(rData);

fprintf('Input read: %d cost rates, %d specifications, %d processes, %d scenarios.\n', ...
    numel(rData.rCost.cLabels), numel(rData.rSpec.cLabels), ...
    numel(rData.rAlloc.cProcesses), numel(rData.rAlloc.cScenarios));
