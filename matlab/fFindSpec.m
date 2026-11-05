function iSpec = fFindSpec(rSpec, sProcess, sFactor)
% fFindSpec  Position of the specification sFactor of process sProcess.
% Returns 0 for a fixed amount (factor '1').
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

if strcmp(sFactor, '1')
    iSpec = 0;
    return
end
iSpec = find(strcmp(rSpec.cProcess, sProcess) & strcmp(rSpec.cName, sFactor), 1);
if isempty(iSpec)
    error('Specification %s of process %s not found.', sFactor, sProcess);
end
end
