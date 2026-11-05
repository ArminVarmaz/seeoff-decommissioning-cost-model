function cOut = fCellToStr(cIn)
% fCellToStr  Converts a cell array from fReadSheet into a cell array of
% character vectors. Numbers become text, missing cells become ''.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cOut = cell(size(cIn));
for iCell = 1:numel(cIn)
    xValue = cIn{iCell};
    if ischar(xValue)
        cOut{iCell} = strtrim(xValue);
    elseif isstring(xValue) && ~ismissing(xValue)
        cOut{iCell} = strtrim(char(xValue));
    elseif isnumeric(xValue) && isscalar(xValue) && ~isnan(xValue)
        cOut{iCell} = num2str(xValue);
    else
        cOut{iCell} = '';
    end
end
end
