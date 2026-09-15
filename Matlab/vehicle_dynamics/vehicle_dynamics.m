function acceleration = vehicle_dynamics(wheel_torque, velocity, grade, params)
% VEHICLE_DYNAMICS
% Calculates longitudinal vehicle acceleration.
%
% Inputs:
%   wheel_torque - Torque applied at the wheels (Nm)
%   velocity     - Vehicle velocity (m/s)
%   grade        - Road gradient angle (rad)
%   params       - Vehicle parameter structure
%
% Output:
%   acceleration - Vehicle longitudinal acceleration (m/s^2)

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

F_drag = 0.5 * rho * Cd * A * velocity^2;

%% Rolling Resistance

F_roll = Crr * m * g;

%% Gradient Force

F_grade = m * g * sin(grade);

%% Net Force

F_net = F_traction - F_drag - F_roll - F_grade;

%% Vehicle Acceleration

acceleration = F_net / m;

end
