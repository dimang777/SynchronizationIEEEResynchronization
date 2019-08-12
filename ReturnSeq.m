% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
% k_result: rank
% Cycles_Idx: Cycle boundaries from CB function
% i: index of boundary (i to i+1 are used)
% Sync: Sync signal

function Permutation = ReturnSeq(Cycles_Idx, i, Sync)
VoltScale = 0.5;
Fs = 1000;
n = 6;
step_length = 2;
cycle_period = 14;

SignalCycle_Integer = round(Sync(Cycles_Idx(i):Cycles_Idx(i+1))./VoltScale);
Permutation = zeros([n 1]);

t = 1.5*step_length; % 2 seconds of initial zero step plus half of non-zero step
idx = 1;
while t < cycle_period
    Permutation(idx) = round(mean(SignalCycle_Integer(t*Fs-5+1:t*Fs+5))); % average of 10 samples around the center
    idx = idx + 1;    
    t = t + step_length;
end



