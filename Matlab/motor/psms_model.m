function [motor_torque, motor_speed] = pmsm_model( ...
    motor_speed, torque_command)
% PMSM_MODEL
% Represents the mechanical output interface of the
% six-phase permanent magnet synchronous motor (PMSM).
%
% Inputs:
%   motor_speed   - Motor speed (rad/s)
%   torque_command - Requested motor torque (Nm)
%
% Outputs:
%   motor_torque  - Motor electromagnetic torque (Nm)
%   motor_speed   - Motor speed (rad/s)
%
% The detailed electrical PMSM and inverter model is represented
% in the Simulink/Simscape model.

%% Motor Torque

motor_torque = torque_command;

end
