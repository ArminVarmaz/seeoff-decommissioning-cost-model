function cNames = fValidName(cNames)
% fValidName  Turns labels into valid MATLAB names, e.g. '1.1.A' -> 'x1_1_A'.
% Labels from the different sheets can then be compared directly.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

cNames = matlab.lang.makeValidName(fCellToStr(cNames));
end
