function [acceleration, forces] = vehicle_dynamics( ...
    vehicle_speed, wheel_torque, grade_angle, params)
% VEHICLE_DYNAMICS
% Calculates the longitudinal dynamics of the electric vehicle.
%
% Inputs:
%   vehicle_speed  - Vehicle speed (m/s)
%   wheel_torque   - Torque available at the wheels (Nm)
%   grade_angle    - Road grade angle (rad)
%   params         - Vehicle parameters from ev_parameters()
%
% Outputs:
%   acceleration   - Vehicle acceleration (m/s^2)
%   forces         - Individual longitudinal forces (N)
%
% The model considers:
%   1. Traction force
%   2. Aerodynamic drag
%   3. Rolling resistance
%   4. Road grade force

%% Vehicle Parameters

m = params.vehicle.mass;
r = params.vehicle.wheel_radius;
Cd = params.vehicle.Cd;
A = params.vehicle.frontal_area;
Crr = params.vehicle.Crr;
rho = params.vehicle.air_density;
g = params.vehicle.gravity;

%% Traction Force

F_traction = wheel_torque / r;

%% Aerodynamic Drag

F_drag = 0.5 * rho * Cd * A * vehicle_speed^2;

%% Rolling Resistance

F_roll = Crr * m * g;

%% Grade Force

F_grade = m * g * sin(grade_angle);

%% Net Force

F_net = F_traction - F_drag - F_roll - F_grade;

%% Vehicle Acceleration

acceleration = F_net / m;

%% Store Individual Forces

forces.traction = F_traction;
forces.drag = F_drag;
forces.rolling = F_roll;
forces.grade = F_grade;
forces.net = F_net;

end
