function Permutation = ReturnSeq(Cycles_Idx, k, Time, Sync)

% Isolate the cycle
Cycle_T = Time(Cycles_Idx(k):Cycles_Idx(k+1));
Cycle_End = Sync(Cycles_Idx(k):Cycles_Idx(k+1));

% Find the steps of the cycle
[StepLocs_T] = GetStepLocations(Cycle_T, Cycle_End);

% Decompose the sequence to find the corresponding permutation
Permutation = DecomposeSequence_Cycle(...
    Cycle_T, Cycle_End, StepLocs_T);
