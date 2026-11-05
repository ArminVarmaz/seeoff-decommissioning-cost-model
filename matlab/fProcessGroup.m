function vGroup = fProcessGroup(cProcesses)
% fProcessGroup  Group of each process from the first digit of its code:
% 1 offshore, 2 and 3 onshore, 4 material revenues.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

vGroup = zeros(numel(cProcesses), 1);
for iProc = 1:numel(cProcesses)
    sDigit = regexp(cProcesses{iProc}, '\d', 'match', 'once');
    vGroup(iProc) = str2double(sDigit);
end
end
