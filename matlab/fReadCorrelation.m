function mCorr = fReadCorrelation(sFile, sSheet, cLabels)
% fReadCorrelation  Reads a correlation sheet. Only the lower triangle is
% filled in the workbook; it is mirrored to the upper triangle. The rows
% and columns are put into the order of cLabels.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cRaw    = fReadSheet(sFile, sSheet);
cNames  = fCellToStr(cRaw(2:end, 1));
lRow    = ~cellfun(@isempty, cNames);
iNum    = sum(lRow);
mLower  = fCellToNum(cRaw(1 + find(lRow), 2:iNum + 1));
mLower(isnan(mLower)) = 0;
mCorr   = tril(mLower, -1) + tril(mLower, -1)' + eye(iNum);
vOrder  = fMatchOrder(fValidName(cNames(lRow)), cLabels);
mCorr   = mCorr(vOrder, vOrder);
end
