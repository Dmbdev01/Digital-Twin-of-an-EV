% RUN_SIMULATION
% Runs the Electric Vehicle Digital Twin simulation
% and displays the main simulation results.

clear;
clc;
close all;

%% Project Paths

project_root = fileparts(fileparts(mfilename('fullpath')));

addpath(genpath(fullfile(project_root, 'matlab')));

%% Drive Cycle

drive_cycle_file = fullfile( ...
    project_root, ...
    'data', ...
    'example', ...
    'example_drive_cycle.csv');

%% Run Simulation

results = digital_twin_main(drive_cycle_file);

%% Plot Results

plot_results(results);
