function mOut = fProjectPsd(mIn)
% fProjectPsd  Nearest positive semidefinite matrix in the Frobenius
% norm: negative eigenvalues are set to zero.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

mIn = (mIn + mIn') / 2;
[mV, mD] = eig(mIn);
vEig = max(diag(mD), 0);
mOut = mV * diag(vEig) * mV';
mOut = (mOut + mOut') / 2;
end
