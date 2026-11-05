function vProb = fShortfallProbability(mOnshore, mRevenue)
% fShortfallProbability  Share of runs in which onshore costs exceed the
% material revenues (revenues are negative, Section 4.3).
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

vProb = mean(mOnshore > -mRevenue, 1);
end
