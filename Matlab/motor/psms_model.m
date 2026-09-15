function [motor_torque, motor_speed] = pmsm_model(control_command, motor_speed, params)
% PMSM_MODEL
% Simplified interface for the six-phase PMSM used in the
% Electric Vehicle Digital Twin.
%
% Inputs:
%   control_command - Motor control command
%   motor_speed     - Motor speed (rad/s)
%   params          - Project parameter structure
%
% Outputs:
%   motor_torque    - Motor torque (Nm)
%   motor_speed     - Motor speed (rad/s)

%% Motor Torque

motor_torque = params.control.torque_gain * control_command;

%% Prevent Negative Torque

motor_torque = max(0, motor_torque);

end
