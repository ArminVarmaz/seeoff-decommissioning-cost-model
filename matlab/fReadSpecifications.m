function rSpec = fReadSpecifications(sFile)
% fReadSpecifications  Reads the sheet 'ProcessSpecifications'. Each row
% is one duration or quantity of one process with its distribution.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cRaw    = fReadSheet(sFile, 'ProcessSpecifications');
cHeader = cRaw(1, :);
cRaw    = cRaw(2:end, :);
cProcess = fCellToStr(cRaw(:, fColumn(cHeader, 'Process')));
lRow     = ~cellfun(@isempty, cProcess);
cRaw     = cRaw(lRow, :);

rSpec.cProcess = fValidName(cProcess(lRow));
rSpec.cName    = fCellToStr(cRaw(:, fColumn(cHeader, 'Specification')));
rSpec.cDist    = fCellToStr(cRaw(:, fColumn(cHeader, 'sDistribution')));
rSpec.mPar     = [fCellToNum(cRaw(:, fColumn(cHeader, 'dParameterA'))), ...
                  fCellToNum(cRaw(:, fColumn(cHeader, 'dParameterB'))), ...
                  fCellToNum(cRaw(:, fColumn(cHeader, 'dParameterC')))];
rSpec.cLabels  = fValidName(strcat(rSpec.cProcess, '_', rSpec.cName));
end
