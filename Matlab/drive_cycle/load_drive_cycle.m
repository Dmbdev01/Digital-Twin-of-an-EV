function [time, speed] = load_drive_cycle(filename)
% LOAD_DRIVE_CYCLE
% Loads the recorded vehicle drive-cycle data.
%
% The drive cycle is based on speed data recorded from
% the physical electric vehicle.
%
% Expected CSV format:
%   Column 1 -> Time (s)
%   Column 2 -> Vehicle Speed (m/s)
%
% Inputs:
%   filename - Path to the drive-cycle CSV file
%
% Outputs:
%   time  - Time vector (s)
%   speed - Vehicle speed vector (m/s)

%% Load Data

data = readmatrix(filename);

%% Check Input

if size(data,2) < 2
    error('Drive-cycle file must contain at least two columns: time and speed.');
end

%% Extract Time and Speed

time = data(:,1);
speed = data(:,2);

%% Basic Validation

if any(isnan(time)) || any(isnan(speed))
    error('Drive-cycle data contains missing or invalid values.');
end

if any(diff(time) < 0)
    error('Time values must be in ascending order.');
end

end
