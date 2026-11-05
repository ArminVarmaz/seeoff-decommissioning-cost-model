function [mCorrNew, rInfo] = fNearestCorr(mCorr, dTol, iMaxIter, dEigTol)
% fNearestCorr  Valid correlation matrix close to mCorr.
% Alternating projections of Higham (2002) with Dykstra's correction:
% projection onto the positive semidefinite matrices, then unit diagonal.
% A final shrinkage toward the identity lifts the smallest eigenvalue to
% at least dEigTol, so that the Cholesky decomposition exists.
%
% Higham NJ. Computing the nearest correlation matrix: a problem from
% finance. IMA J Numer Anal 2002;22(3):329-43.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

iNum   = size(mCorr, 1);
mY     = (mCorr + mCorr') / 2;
mDelta = zeros(iNum);
for iIter = 1:iMaxIter
    mR     = mY - mDelta;
    mX     = fProjectPsd(mR);
    mDelta = mX - mR;
    mYOld  = mY;
    mY     = mX;
    mY(1:iNum + 1:end) = 1;
    if norm(mY - mYOld, 'fro') < dTol
        break
    end
end
mY = (mY + mY') / 2;
dLambdaMin = min(eig(mY));
dShrinkage = max(0, (dEigTol - dLambdaMin) / (1 - dLambdaMin));
mCorrNew = (1 - dShrinkage) * mY + dShrinkage * eye(iNum);
mCorrNew = (mCorrNew + mCorrNew') / 2;
mCorrNew(1:iNum + 1:end) = 1;
rInfo.iIterations = iIter;
rInfo.dShrinkage  = dShrinkage;
end
