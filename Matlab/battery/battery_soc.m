function soc = battery_soc(current, previous_soc, dt, params)
% BATTERY_SOC
% Calculates battery State of Charge using Coulomb counting.
%
% Inputs:
%   current     - Battery current (A)
%   previous_soc - SOC from previous time step (0 to 1)
%   dt          - Simulation time step (s)
%   params      - Battery parameter structure
%
% Output:
%   soc         - Updated battery SOC (0 to 1)

%% Battery Parameters

capacity_Ah = params.battery.capacity_Ah;

%% Coulomb Counting

% Convert battery capacity from Ah to Coulombs
capacity_C = capacity_Ah * 3600;

% Update SOC
soc = previous_soc - (current * dt) / capacity_C;

%% Limit SOC

soc = max(0, min(1, soc));

end
