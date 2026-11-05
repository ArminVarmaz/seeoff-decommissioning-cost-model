function fWriteSheet(cData, sFile, sSheet)
% fWriteSheet  Writes a cell array to one sheet of an Excel workbook.
% Under Octave, a CSV file named after the workbook and the sheet is
% written instead, e.g. Results_NetCostPerMW.csv.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

if ~fIsOctave()
    writecell(cData, sFile, 'Sheet', sSheet);
    return
end
[sFolder, sName] = fileparts(sFile);
iFile = fopen(fullfile(sFolder, [sName, '_', sSheet, '.csv']), 'w');
for iRow = 1:size(cData, 1)
    cLine = fCellToStr(cData(iRow, :));
    for iCol = 1:size(cData, 2)
        if isnumeric(cData{iRow, iCol}) && isscalar(cData{iRow, iCol})
            cLine{iCol} = sprintf('%.10g', cData{iRow, iCol});
        end
    end
    fprintf(iFile, '%s\n', strjoin(cLine, ';'));
end
fclose(iFile);
end
