function [mCorrUsed, rInfo] = fCorrectCorrelation(mCorr, cDist, mPar, sStopRule)
% fCorrectCorrelation  Returns mCorr unchanged if it is a valid
% correlation matrix, else the corrected matrix from fNearestCorr.
%
% sStopRule 'paper': the projections stop once the change between two
% iterations is smaller than the smallest standard deviation of the
% inputs. This is the rule of the runs reported in the paper (3 and 10
% iterations, Appendix A). 'converge': tolerance 1e-8 (42 and 61
% iterations in the paper data, Supplementary Section S6).
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

dEigTol = 1e-10;
rInfo.dLambdaMinSpecified = min(eig((mCorr + mCorr') / 2));
if rInfo.dLambdaMinSpecified >= dEigTol
    mCorrUsed = mCorr;
    rInfo.lCorrected = false;
    return
end
if strcmpi(sStopRule, 'paper')
    dTol = min(fInputStd(cDist, mPar));
else
    dTol = 1e-8;
end
[mCorrUsed, rNear] = fNearestCorr(mCorr, dTol, 1000, dEigTol);
rInfo.lCorrected = true;
rInfo.iIterations = rNear.iIterations;
rInfo.dShrinkage  = rNear.dShrinkage;
rInfo.dLambdaMinUsed = min(eig(mCorrUsed));
rInfo.dFrobenius  = norm(mCorrUsed - mCorr, 'fro');
rInfo.dMaxChange  = max(abs(mCorrUsed(:) - mCorr(:)));
end
