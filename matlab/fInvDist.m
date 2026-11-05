function vX = fInvDist(vU, sDist, vPar)
% fInvDist  Inverse distribution function for one input.
% Normal: A = mean, B = standard deviation.
% Triangular: A = minimum, B = mode, C = maximum.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

switch lower(sDist)
    case 'normal'
        vX = vPar(1) - vPar(2) * sqrt(2) * erfcinv(2 * vU);
    case 'triangular'
        vX = fTriInv(vU, vPar(1), vPar(2), vPar(3));
    otherwise
        error('Unknown distribution %s.', sDist);
end
end
