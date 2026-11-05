% b4_RandomNumbers.m
% Draws correlated inputs for both blocks and rejects invalid draws.
% A draw is invalid if a cost rate is negative, a revenue rate is
% positive, or a duration or quantity is negative.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

rng(rSettings.iSeed, 'twister');
iNumDraws = ceil(rSettings.iNumSimulations * rSettings.dOversampling);

% Block 1: cost rates. Revenues have a negative location parameter.
mDrawsCost = fCorrRandomNumbers(iNumDraws, rData.rCost.cDist, ...
    rData.rCost.mPar, rData.rCost.mCorrUsed);
lRevenue   = rData.rCost.mPar(:, 1) < 0;
lValidCost = fValidDraws(mDrawsCost, lRevenue);

% Block 2: durations and quantities. All must be non-negative.
mDrawsSpec = fCorrRandomNumbers(iNumDraws, rData.rSpec.cDist, ...
    rData.rSpec.mPar, rData.rSpec.mCorrUsed);
lValidSpec = fValidDraws(mDrawsSpec, false(size(mDrawsSpec, 2), 1));

rData.mDrawsCost = fKeepValid(mDrawsCost, lValidCost, rSettings.iNumSimulations);
rData.mDrawsSpec = fKeepValid(mDrawsSpec, lValidSpec, rSettings.iNumSimulations);
rData.rRejection.dShareCost = mean(~lValidCost);
rData.rRejection.dShareSpec = mean(~lValidSpec);
clear mDrawsCost mDrawsSpec lValidCost lValidSpec lRevenue iNumDraws
