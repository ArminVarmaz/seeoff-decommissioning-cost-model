function cRaw = fReadSheet(sFile, sSheet)
% fReadSheet  Reads one sheet of an Excel workbook into a cell array.
% MATLAB: readcell (R2019a or later). Octave: xlsread of the io package.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

if fIsOctave()
    pkg load io
    [~, ~, cRaw] = xlsread(sFile, sSheet);
else
    cRaw = readcell(sFile, 'Sheet', sSheet);
end
end
