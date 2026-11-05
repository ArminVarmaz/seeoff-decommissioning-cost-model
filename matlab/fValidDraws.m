function lValid = fValidDraws(mDraws, lRevenue)
% fValidDraws  True for draws without a negative cost, duration, or
% quantity and without a positive revenue rate (revenues are negative).
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

lBadCost    = any(mDraws(:, ~lRevenue) < 0, 2);
lBadRevenue = any(mDraws(:, lRevenue) > 0, 2);
lValid      = ~(lBadCost | lBadRevenue);
end
