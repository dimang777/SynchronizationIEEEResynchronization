% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.

% Revisions
% v1.020 Modify the 0.2 seconds from 200 samples to the fraction of the
% length of step (10% of a 2-second long step)
% v1.010 Sync signal does not have to be in the values of (0, 0.5, 1.0, 1.5, 2.0, 2.5, 3)
% v1.000 Sync signal should be in the values of (0, 0.5, 1.0, 1.5, 2.0, 2.5, 3)
function Sequence = Func_DecomposeSequence_Cycle(CycleSignal_T, CycleSignal, CycleSignal_boundary)
% Normalize the signal to have maximum of 3
CycleSignal_Norm = CycleSignal./max(CycleSignal).*3;

% Decompose the cycle into levels

if ~iscolumn(CycleSignal_T)
    CycleSignal_T = CycleSignal_T';
end
Sequence = zeros([6 1]);
for i = 1:length(CycleSignal_boundary)
    if i == length(CycleSignal_boundary)
        StartIndex = dsearchn(CycleSignal_T, CycleSignal_boundary(i));
        EndIndex = length(CycleSignal_T);
    else
        StartIndex = dsearchn(CycleSignal_T, CycleSignal_boundary(i));
        EndIndex = dsearchn(CycleSignal_T, CycleSignal_boundary(i+1));
    end
% average about 0.2 seconds inward from the step changes. This means given
% 2 seconds for each step, go about 10% inward from the step changes

Indent = round((length(CycleSignal_T)/7)*0.1);
Sequence(i) = round(mean(CycleSignal_Norm(StartIndex+Indent:EndIndex-Indent))*2);
end
