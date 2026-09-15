function voltage = battery_voltage(soc)
% BATTERY_VOLTAGE
% Estimates battery voltage from the voltage-SOC characteristic.
%
% Input:
%   soc      - Battery State of Charge (0 to 1)
%
% Output:
%   voltage  - Battery voltage (V)
%
% The characteristic is based on the battery voltage-SOC
% relationship used in the project.

%% Voltage-SOC Data

soc_points = [100 90 80 70 60 50 40 30 20 10 0] / 100;

voltage_points = [58.8 57.4 56.0 55.02 53.76 ...
                  52.92 52.08 50.96 49.70 47.46 35.0];

%% Interpolate Battery Voltage

voltage = interp1( ...
    soc_points, ...
    voltage_points, ...
    soc, ...
    'linear', ...
    'extrap');

%% Limit SOC

if soc <= 0
    voltage = voltage_points(end);
elseif soc >= 1
    voltage = voltage_points(1);
end

end
