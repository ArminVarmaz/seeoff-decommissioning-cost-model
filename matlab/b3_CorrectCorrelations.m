% b3_CorrectCorrelations.m
% Corrects both specified correlation matrices to valid (positive
% definite) correlation matrices, see Section 3.3 and Appendix A.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

if rSettings.lIndependence
    rData.rCost.mCorrUsed = eye(numel(rData.rCost.cLabels));
    rData.rSpec.mCorrUsed = eye(numel(rData.rSpec.cLabels));
    rData.rCost.rCorrInfo = struct('lCorrected', false);
    rData.rSpec.rCorrInfo = struct('lCorrected', false);
else
    [rData.rCost.mCorrUsed, rData.rCost.rCorrInfo] = fCorrectCorrelation( ...
        rData.rCost.mCorrSpecified, rData.rCost.cDist, rData.rCost.mPar, rSettings.sStopRule);
    [rData.rSpec.mCorrUsed, rData.rSpec.rCorrInfo] = fCorrectCorrelation( ...
        rData.rSpec.mCorrSpecified, rData.rSpec.cDist, rData.rSpec.mPar, rSettings.sStopRule);
end
