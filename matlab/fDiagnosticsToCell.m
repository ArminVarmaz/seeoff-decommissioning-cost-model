function cTable = fDiagnosticsToCell(rData)
% fDiagnosticsToCell  Correction of the correlation matrices and
% rejection of invalid draws (Appendix A), one column per block.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cTable = {'Diagnostic', 'Cost rates', 'Durations and quantities'};
cBlock = {rData.rCost.rCorrInfo, rData.rSpec.rCorrInfo};
cTable(end + 1, :) = [{'Correction applied'}, ...
    {double(cBlock{1}.lCorrected), double(cBlock{2}.lCorrected)}];
cFields = {'dLambdaMinSpecified', 'iIterations', 'dShrinkage', ...
           'dLambdaMinUsed', 'dFrobenius', 'dMaxChange'};
for iField = 1:numel(cFields)
    cRow = {cFields{iField}, NaN, NaN};
    for iBlock = 1:2
        if isfield(cBlock{iBlock}, cFields{iField})
            cRow{iBlock + 1} = cBlock{iBlock}.(cFields{iField});
        end
    end
    cTable(end + 1, :) = cRow; %#ok<AGROW>
end
cTable(end + 1, :) = {'Rejected share', rData.rRejection.dShareCost, ...
                      rData.rRejection.dShareSpec};
end
