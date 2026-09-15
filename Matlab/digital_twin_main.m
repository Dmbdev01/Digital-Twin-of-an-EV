function results = digital_twin_main(drive_cycle_file)
% DIGITAL_TWIN_MAIN
% Main simulation script for the Electric Vehicle Digital Twin.
%
% The simulation uses recorded vehicle speed data as the
% reference drive cycle and calculates vehicle response,
% drivetrain behavior, and battery SOC.
%
% Input:
%   drive_cycle_file - CSV file containing time and speed data
%
% Output:
%   results - Structure containing simulation results

%% Load Parameters

params = ev_parameters();

%% Load Drive Cycle

[time, vel_ref] = load_drive_cycle(drive_cycle_file);

%% Initialize Simulation

n = length(time);

vel_sim = zeros(n,1);
acceleration = zeros(n,1);

motor_speed = zeros(n,1);
motor_torque = zeros(n,1);
wheel_torque = zeros(n,1);

battery_current = zeros(n,1);
soc = zeros(n,1);

initial_soc = params.battery.initial_SOC;

soc(1) = initial_soc;

%% Simulation Loop

for k = 2:n

    dt = time(k) - time(k-1);

    %% Longitudinal Driver

    [accel_cmd, decel_cmd] = longitudinal_driver( ...
        vel_ref(k), ...
        vel_sim(k-1), ...
        0);

    %% Convert Driver Command to Torque Command
    %
    % This provides the connection between the driver stage
    % and the powertrain. The relationship can be calibrated
    % against the original Simulink model.

    torque_command = accel_cmd * params.control.torque_gain;

    if decel_cmd > 0
        torque_command = -decel_cmd * 100;
    end

    %% Motor

    motor_speed(k) = vel_sim(k-1) / ...
        params.vehicle.wheel_radius * ...
        params.drivetrain.gear_ratio;

    [motor_torque(k), ~] = pmsm_model( ...
        motor_speed(k), ...
        torque_command);

    %% Drivetrain

    [wheel_torque(k), ~] = powertrain( ...
        motor_torque(k), ...
        motor_speed(k), ...
        params);

    %% Vehicle Dynamics

    [acceleration(k), ~] = vehicle_dynamics( ...
        vel_sim(k-1), ...
        wheel_torque(k), ...
        0, ...
        params);

    %% Integrate Vehicle Speed

    vel_sim(k) = vel_sim(k-1) + ...
        acceleration(k) * dt;

    % Prevent negative vehicle speed
    vel_sim(k) = max(vel_sim(k), 0);

    %% Estimate Battery Current

    battery_current(k) = abs(motor_torque(k) * ...
        motor_speed(k)) / ...
        max(params.battery.nominal_voltage, 1);

    %% Update SOC

    soc(k) = soc(k-1) - ...
        (battery_current(k) * dt) / ...
        (3600 * params.battery.capacity_Ah);

    soc(k) = max(0, min(1, soc(k)));

end

%% Distance

distance = cumtrapz(time, vel_sim);

%% Store Results

results.time = time;
results.reference_speed = vel_ref;
results.simulated_speed = vel_sim;
results.acceleration = acceleration;
results.motor_speed = motor_speed;
results.motor_torque = motor_torque;
results.wheel_torque = wheel_torque;
results.battery_current = battery_current;
results.soc = soc;
results.distance = distance;

end
