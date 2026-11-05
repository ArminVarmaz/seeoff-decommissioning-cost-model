function mOut = fKeepValid(mDraws, lValid, iNumKeep)
% fKeepValid  Keeps the first iNumKeep valid draws.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

mOut = mDraws(lValid, :);
if size(mOut, 1) < iNumKeep
    error('Only %d valid draws. Increase dOversampling.', size(mOut, 1));
end
mOut = mOut(1:iNumKeep, :);
end
