function [accel_cmd, decel_cmd] = longitudinal_driver( ...
    vel_ref, vel_fdbk, grade)
% LONGITUDINAL_DRIVER
% Generates acceleration and deceleration commands based on
% the difference between reference and feedback vehicle speed.
%
% Inputs:
%   vel_ref   - Reference vehicle speed (m/s)
%   vel_fdbk  - Feedback vehicle speed (m/s)
%   grade     - Road grade (rad)
%
% Outputs:
%   accel_cmd - Acceleration command
%   decel_cmd - Deceleration command
%
% The block represents the longitudinal driver stage of the
% EV simulation, where the desired vehicle speed is compared
% with the simulated vehicle speed.

%% Speed Error

speed_error = vel_ref - vel_fdbk;

%% Driver Command

if speed_error >= 0
    accel_cmd = speed_error;
    decel_cmd = 0;
else
    accel_cmd = 0;
    decel_cmd = -speed_error;
end

%% Grade Compensation

% Grade is provided as an input because road inclination
% affects the force required to follow the reference speed.

if grade ~= 0
    accel_cmd = accel_cmd - sin(grade);
end

%% Limit Commands

accel_cmd = max(accel_cmd, 0);
decel_cmd = max(decel_cmd, 0);

end
