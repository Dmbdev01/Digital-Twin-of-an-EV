% RUN_SIMULATION
% Runs the Electric Vehicle Digital Twin simulation
% and displays the main simulation results.

clear;
clc;
close all;

%% Drive Cycle

drive_cycle_file = ...
    'data/example_drive_cycle.csv';

%% Run Simulation

results = digital_twin_main(drive_cycle_file);

%% Plot Results

plot_results(results);
