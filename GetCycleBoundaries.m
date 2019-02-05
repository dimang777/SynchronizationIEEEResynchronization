% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.

% Revisions
% v1.030 Ignore first 10 samples to avoid confusion
% v1.020 Look for 14s period when deciding the boundaries
% v1.010 Sync signal does not have to be in the values of (0, 0.5, 1.0, 1.5, 2.0, 2.5, 3)
% v1.000 Sync signal should be in the values of (0, 0.5, 1.0, 1.5, 2.0, 2.5, 3)
function Cycle_Boundaries_Indices = ...
    GetCycleBoundaries(Signal_T ,Signal)

% Each cycle is 14s long. Therefore the minimum distance is set to 13.5s.
MinInterval = 13.5;

% Normalize the signal to have maximum of 3
Signal_Norm = Signal./max(Signal).*3;

% Get boundaries
Signal_zeros_indices = [zeros([10 1]); 0.1>Signal_Norm(11:end)];
Signal_zeros_indices_diff = diff(Signal_zeros_indices);

Cycle_Boundaries_Indices = find(Signal_zeros_indices_diff==1)+1;

i = 1;
while i  < length(Cycle_Boundaries_Indices)

    if Signal_T(Cycle_Boundaries_Indices(i+1)) - Signal_T(Cycle_Boundaries_Indices(i)) < MinInterval
        Cycle_Boundaries_Indices(i+1) = [];
    else
        i = i + 1;
    end

end




