% b1_CreateCorrelations.m
% Optional. Replaces the two correlation sheets of the synthetic input
% workbook with new random correlation matrices from gallery('randcorr').
% These matrices are valid correlation matrices by construction.
% Labels and order are taken from the existing sheets.
% MATLAB only: Octave has no gallery('randcorr').
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

clear; clc;

sFileInput = fullfile('..', 'data', 'InputSynthetic.xlsx');
iSeed      = 1;
rng(iSeed, 'twister');

cSheets = {'CorrelationCostRates', 'CorrelationSpecifications'};
for iSheet = 1:numel(cSheets)
    cRaw    = fReadSheet(sFileInput, cSheets{iSheet});
    cLabels = cRaw(2:end, 1);
    iNum    = numel(cLabels);
    mCorr   = gallery('randcorr', iNum);
    cOut    = fCorrToCell(mCorr, cLabels);
    fWriteSheet(cOut, sFileInput, cSheets{iSheet});
end
disp('New random correlation matrices written.');
