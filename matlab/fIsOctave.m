function lOctave = fIsOctave()
% fIsOctave  True if the code runs under GNU Octave, false under MATLAB.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

lOctave = exist('OCTAVE_VERSION', 'builtin') > 0;
end
