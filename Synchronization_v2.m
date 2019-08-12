% Variables
% S_R: Sync signal of reference
% T_R: Time vector of reference
% T_S: Time vector of the signal to be synced
% S_S: Sync signal of the signal to be synced
% D_S: Signal to be synced

% Find the boundary of each cycle
for Condense = 1
CB_R = CB(S_R);
CB_S = CB(S_S); 
end

% Find the ranks of the first and last permutations
k_R_1st = Find_k(CB_R, 1, S_R);
k_R_last = Find_k(CB_R, length(CB_R)-1, S_R);
k_S_1st = Find_k(CB_S, 1, S_S);
k_S_last = Find_k(CB_S, length(CB_S)-1, S_S);

% Designate start indices
if k_S_1st < k_R_1st
    Idx_R = abs(k_R_1st - k_S_1st) + 1;
else
    Idx_R = 1;
end

if k_S_1st > k_R_1st
    Idx_S = abs(k_R_1st - k_S_1st) + 1;
else
    Idx_S = 1;
end


% Loop count
Cnt_Cycles = min(k_R_last, k_S_last) - max(k_R_1st, k_S_1st);

% Crop signals with no sequency pair between the reference and the signal
% to sync
T_Total_BfrCrop = zeros([length(T_S) 1]);

for i = 1:Cnt_Cycles

% e.g., 
% CB1 = 200; CB2 = 300 - from 200 to 299. 100 data points
% 300 - 200 = 100
N_Cycle_D_S = length(D_S(CB_S(Idx_S+i-1):CB_S(Idx_S+i)-1));

% e.g., linspace(1, 2, 101)
Cycle_T_S = linspace(T_R(CB_R(Idx_R+i-1)), T_R(CB_R(Idx_R+i)), N_Cycle_D_S+1);

% Remove the last point since it belongs to the next cycle
T_Total_BfrCrop(CB_S(Idx_S+i-1):CB_S(Idx_S+i)-1) = Cycle_T_S(1:end-1);

end

T_Total = T_Total_BfrCrop(CB_S(Idx_R):CB_S(Idx_R+Cnt_Cycles)-1);
D_Total = D_S(CB_S(Idx_R):CB_S(Idx_R+Cnt_Cycles)-1);


% Resample
Idx_Start_R = dsearchn(T_R(:), T_Total(1));
Idx_End_R = dsearchn(T_R(:), T_Total(end));

D_S_Syn = Func_Resample2(T_Total, D_Total, T_R(Idx_Start_R:Idx_End_R));

T_S_Syn = T_R(Idx_Start_R:Idx_End_R);
