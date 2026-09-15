function params = ev_parameters()
% EV_PARAMETERS
% Parameters used for the Electric Vehicle Digital Twin.
%
% This file contains the main vehicle, drivetrain, battery,
% and simulation parameters used by the model.
%
% Vehicle parameters can be calibrated using experimental
% measurements when required.

%% Vehicle Parameters

params.vehicle.mass = 230;              % Vehicle mass (kg)
params.vehicle.wheel_radius = 0.25;     % Wheel radius (m)
params.vehicle.Cd = 0.3;                % Aerodynamic drag coefficient
params.vehicle.frontal_area = 1.2;      % Frontal area (m^2)
params.vehicle.Crr = 0.015;             % Rolling resistance coefficient
params.vehicle.air_density = 1.225;     % Air density (kg/m^3)
params.vehicle.gravity = 9.81;          % Gravitational acceleration (m/s^2)

%% Drivetrain Parameters

params.drivetrain.gear_ratio = 6.5;     % Overall gear reduction
params.drivetrain.efficiency = 0.90;    % Drivetrain efficiency

%% Control Parameters

params.control.torque_gain = 100;       % Driver command to torque scaling

%% Battery Parameters

params.battery.nominal_voltage = 51.6;  % Nominal battery voltage (V)
params.battery.capacity_Ah = 120;       % Battery capacity (Ah)
params.battery.initial_SOC = 1.0;       % Initial SOC (100%)

%% Simulation Parameters

params.simulation.sample_time = 0.01;    % Simulation sample time (s)

end
