function [time, speed] = load_drive_cycle(filename)
% LOAD_DRIVE_CYCLE
% Loads electric vehicle drive-cycle data from a CSV file.
%
% Inputs:
%   filename - Path to the drive-cycle CSV file
%
% Outputs:
%   time  - Time vector (s)
%   speed - Vehicle speed vector (m/s)

%% Load Data

data = readtable(filename);

%% Extract Time and Speed

time = data.Time_s;
speed = data.Speed_mps;

%% Ensure Column Vectors

time = time(:);
speed = speed(:);

end
