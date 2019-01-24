% v1.012 - Use Func_GetStepLocations function
% v1.011 - Use 0.1 as threshold
% v1.010 - Sync signal does not have to be in the values of (0, 0.5, 1.0, 1.5, 2.0, 2.5, 3)
% v1.001 - Sync signal should be in the values of (0, 0.5, 1.0, 1.5, 2.0, 2.5, 3)
function [Signal_FirstCycle_T, Signal_FirstCycle, Signal_FirstCycle_StepLocations_T] = ...
    Func_IsolateFirstCycleofSyncSignal(Signal_T ,Signal)
% Normalize the signal to have maximum of 3
Signal_Norm = Signal./max(Signal).*3;

% Isolate first cycle of syncronization wave

Signal_zeros_indices = 0.1>Signal_Norm;
Signal_diff_pos_change_indices = 0.1 < diff(Signal_Norm);
Signal_diff_neg_change_indices = -0.1 < diff(Signal_Norm);
Signal_zeros_indices_diff = diff(Signal_zeros_indices);

figure(1); clf; hold on;
plot(Signal_zeros_indices);
plot(Signal_diff_pos_change_indices, '--r');
plot(Signal_diff_neg_change_indices, '--y');
plot(Signal_zeros_indices_diff, 'kx');

Signal_FirstSet_StartIndex = find(Signal_zeros_indices_diff==1,1)+1;
temp = find(Signal_zeros_indices_diff==1,2);
Signal_FirstSet_EndIndex = temp(2);
Signal_FirstCycle = Signal_Norm(Signal_FirstSet_StartIndex:Signal_FirstSet_EndIndex);
Signal_FirstCycle_T = Signal_T(Signal_FirstSet_StartIndex:Signal_FirstSet_EndIndex);

[Signal_FirstCycle_StepLocations_T] = ...
    Func_GetStepLocations(Signal_FirstCycle_T, ...
    Signal_FirstCycle);

% Remove multiple points in one location
Signal_FirstCycle_StepLocations_T(find(1 > diff(Signal_FirstCycle_StepLocations_T))+1) = [];
