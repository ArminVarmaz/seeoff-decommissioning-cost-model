function rAlloc = fReadAllocation(sFile)
% fReadAllocation  Reads which resources each process uses (sheet
% 'ProcessResources', entries = number of units) and which processes
% each scenario contains (sheet 'ScenarioProcesses', entries 0 or 1).
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cRaw = fReadSheet(sFile, 'ProcessResources');
cProcesses = fCellToStr(cRaw(1, 2:end));
lCol       = ~cellfun(@isempty, cProcesses);
cResources = fCellToStr(cRaw(2:end, 1));
lRow       = ~cellfun(@isempty, cResources);
mUnits     = fCellToNum(cRaw(2:end, 2:end));
mUnits     = mUnits(lRow, lCol);
mUnits(isnan(mUnits)) = 0;

rAlloc.cProcesses = fValidName(cProcesses(lCol))';
rAlloc.cResources = fValidName(cResources(lRow));
rAlloc.mUnits     = mUnits;                       % resources x processes
rAlloc.vGroup     = fProcessGroup(rAlloc.cProcesses);

cRaw = fReadSheet(sFile, 'ScenarioProcesses');
cScenarios = fCellToStr(cRaw(1, 2:end));
lCol       = ~cellfun(@isempty, cScenarios);
cRows      = fCellToStr(cRaw(2:end, 1));
lRow       = ~cellfun(@isempty, cRows);
mScen      = fCellToNum(cRaw(2:end, 2:end));
mScen      = mScen(lRow, lCol);
vOrder     = fMatchOrder(fValidName(cRows(lRow)), rAlloc.cProcesses);

rAlloc.cScenarios = cScenarios(lCol);
rAlloc.lScenario  = mScen(vOrder, :) == 1;        % processes x scenarios
end
