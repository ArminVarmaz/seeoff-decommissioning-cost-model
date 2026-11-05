function rCost = fReadCostRates(sFile)
% fReadCostRates  Reads the sheet 'Resources'. Each row is one cost
% element of one resource: a rate, its distribution, and the name of the
% duration or quantity it is multiplied with ('1' for a fixed amount).
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cRaw    = fReadSheet(sFile, 'Resources');
cHeader = cRaw(1, :);
cRaw    = cRaw(2:end, :);
cResource = fCellToStr(cRaw(:, fColumn(cHeader, 'Resource')));
lRow      = ~cellfun(@isempty, cResource);
cRaw      = cRaw(lRow, :);

rCost.cResource = fValidName(cResource(lRow));
rCost.cElement  = fCellToStr(cRaw(:, fColumn(cHeader, 'CostElement')));
rCost.cFactor   = fCellToStr(cRaw(:, fColumn(cHeader, 'sFactor')));
rCost.cDist     = fCellToStr(cRaw(:, fColumn(cHeader, 'sDistribution')));
rCost.mPar      = [fCellToNum(cRaw(:, fColumn(cHeader, 'dParameterA'))), ...
                   fCellToNum(cRaw(:, fColumn(cHeader, 'dParameterB'))), ...
                   fCellToNum(cRaw(:, fColumn(cHeader, 'dParameterC')))];
rCost.cLabels   = fValidName(strcat(rCost.cResource, '_', rCost.cElement));
end
