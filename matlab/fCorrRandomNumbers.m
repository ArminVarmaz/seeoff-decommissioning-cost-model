function mDraws = fCorrRandomNumbers(iNumDraws, cDist, mPar, mCorr)
% fCorrRandomNumbers  Correlated draws through a Gaussian copula.
% Standard normal variables are correlated with the Cholesky factor of
% mCorr and transformed with the inverse distribution function of each
% input (Section 3.3). One row per draw, one column per input.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

iNumVar = numel(cDist);
mZ = randn(iNumDraws, iNumVar) * chol(mCorr);
mU = fNormCdf(mZ);
mDraws = NaN(iNumDraws, iNumVar);
for iVar = 1:iNumVar
    mDraws(:, iVar) = fInvDist(mU(:, iVar), cDist{iVar}, mPar(iVar, :));
end
end
