function mP = fNormCdf(mZ)
% fNormCdf  Distribution function of the standard normal distribution.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

mP = 0.5 * erfc(-mZ / sqrt(2));
end
