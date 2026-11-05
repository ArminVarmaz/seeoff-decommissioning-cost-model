function iCol = fColumn(cHeader, sName)
% fColumn  Position of the column sName in a header row (case insensitive).
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

iCol = find(strcmpi(fCellToStr(cHeader), sName), 1);
if isempty(iCol)
    error('Column %s not found.', sName);
end
end
