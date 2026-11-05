function vIdx = fMatchOrder(cFrom, cTo)
% fMatchOrder  Index vector with cFrom(vIdx) equal to cTo.
% Stops with an error if a label of cTo is missing in cFrom.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

vIdx = zeros(numel(cTo), 1);
for iLabel = 1:numel(cTo)
    iPos = find(strcmp(cFrom, cTo{iLabel}), 1);
    if isempty(iPos)
        error('Label %s not found.', cTo{iLabel});
    end
    vIdx(iLabel) = iPos;
end
end
