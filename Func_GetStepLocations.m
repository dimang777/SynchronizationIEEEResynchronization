% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.

% Revisions
% v1.010 - Implemented keeping at multiples of 2 seconds
% v1.000
function Signal_FirstCycle_StepLocations_T2 = ...
    Func_GetStepLocations(SignalCycle_T ,SignalCycle)
% Normalize the signal to have maximum of 3
SignalCycle_Norm = SignalCycle./max(SignalCycle).*3;

% Get step locations
Signal_FirstCycle_StepLocations_T = SignalCycle_T(find(0.25 < abs(diff(SignalCycle_Norm)))+1);

% Only keep the ones at multiples of 2 seconds. Add the first element to
% the OneSecQuantity calculation (it makes difference when fs is low and
% index is used (blanky). 
OneSecQuantity = (SignalCycle_T(end) - SignalCycle_T(1) + diff(SignalCycle_T(1:2)))/14; % Note that it's quantity not seconds since some T's are index and not time.
SearchRange = 0.2;
for i = 1:6
    StepLoc = 2*i;
    temp = ...
        Signal_FirstCycle_StepLocations_T...
        ((OneSecQuantity*(StepLoc-SearchRange)+SignalCycle_T(1)) < Signal_FirstCycle_StepLocations_T & ...
        Signal_FirstCycle_StepLocations_T < (OneSecQuantity*(StepLoc+SearchRange)+SignalCycle_T(1)));
    Signal_FirstCycle_StepLocations_T2(i) = temp(1);
end

