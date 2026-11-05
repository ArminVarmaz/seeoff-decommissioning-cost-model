function cOut = fCorrToCell(mCorr, cLabels)
% fCorrToCell  Correlation matrix in the layout of the input workbook:
% labels in the first row and column, lower triangle only.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

iNum = numel(cLabels);
cOut = cell(iNum + 1, iNum + 1);
cOut{1, 1} = 'Row';
cOut(1, 2:end) = cLabels(:)';
cOut(2:end, 1) = cLabels(:);
for iRow = 1:iNum
    cOut(iRow + 1, 2:iRow + 1) = num2cell(round(mCorr(iRow, 1:iRow), 4));
end
end
