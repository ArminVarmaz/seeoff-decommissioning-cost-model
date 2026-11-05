function vStd = fInputStd(cDist, mPar)
% fInputStd  Standard deviation of each input from its distribution.
% Normal: parameter B. Triangular (A = min, B = mode, C = max): closed form.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

vStd = NaN(numel(cDist), 1);
for iVar = 1:numel(cDist)
    dA = mPar(iVar, 1); dB = mPar(iVar, 2); dC = mPar(iVar, 3);
    switch lower(cDist{iVar})
        case 'normal'
            vStd(iVar) = dB;
        case 'triangular'
            vStd(iVar) = sqrt((dA^2 + dB^2 + dC^2 - dA*dB - dA*dC - dB*dC) / 18);
        otherwise
            error('Unknown distribution %s.', cDist{iVar});
    end
end
end
