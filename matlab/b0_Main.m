% b0_Main.m
% Master script of the simplified SeeOff decommissioning cost model.
% It sets all options and runs the scripts b2 to b6 in order.
% Run it from this folder. b1_CreateCorrelations.m is optional and is
% not called here.
%
% Reference: Varmaz, A. (2026). Process-based Monte Carlo cost simulation
% for offshore wind farm decommissioning: A scenario analysis for the
% German North Sea. Renewable Energy. https://doi.org/10.1016/j.renene.2026.126679

%
% Copyright (c) 2026 Armin Varmaz, Hochschule Bremen.
% License: CC BY-NC 4.0, see LICENSE.

clear; clc; close all;

%% Settings
rSettings = struct();
rSettings.sFileInput      = fullfile('..', 'data', 'InputSynthetic.xlsx');
rSettings.sFolderResults  = fullfile('..', 'results');
rSettings.iNumSimulations = 100000;   % valid draws per block
rSettings.dOversampling   = 1.4;      % draws generated per valid draw
rSettings.iSeed           = 20261105; % seed of the random number generator
rSettings.iNumTurbines    = 80;       % number of foundation locations
rSettings.dTurbineMW      = 3.6;      % rated power per turbine in MW
rSettings.sBaseline       = 'BS';     % name of the baseline scenario
rSettings.lIndependence   = false;    % true: all correlations set to zero
rSettings.sStopRule       = 'paper';  % 'paper' or 'converge', see fNearestCorr

%% Model run
b2_ReadInput            % read the Excel workbook into rData
b3_CorrectCorrelations  % make both correlation matrices valid
b4_RandomNumbers        % correlated draws and rejection of invalid draws
b5_Calculate            % costs per process and per scenario
b6_Results              % tables, figure, and result files
