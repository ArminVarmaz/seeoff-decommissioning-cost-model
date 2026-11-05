function mOut = fCellToNum(cIn)
% fCellToNum  Converts a cell array from fReadSheet into a numeric matrix.
% Text and missing cells become NaN.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

mOut = NaN(size(cIn));
for iCell = 1:numel(cIn)
    xValue = cIn{iCell};
    if isnumeric(xValue) && isscalar(xValue)
        mOut(iCell) = double(xValue);
    elseif ischar(xValue) && ~isempty(str2double(xValue)) && ~isnan(str2double(xValue))
        mOut(iCell) = str2double(xValue);
    end
end
end
