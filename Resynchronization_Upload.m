% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
% Variables
% D_1 % Signal 1 data
% S_1 % Synchronization signal of Signal 1
% T_1 % Time variable of Signal 1
% D_2 % Signal 2 data
% S_2 % Synchronization signal of Signal 2
% T_2 % Time variable of Signal 2
% S_Tem % Template synchronization signal
% T_Tem % Time variable of the template synchronization signal

n = 6;
VoltScale = 0.5;
MaxNum = 720; % 6!
Step_length = 2; % 2 seconds
Fs = 1000;
%% 
Cyc_1_Idx = CB(S_1);
k_1_End = Getk(S_1(Cyc_1_Idx(end-1):Cyc_1_Idx(end)));

Cyc_2_Idx = CB(S_2); 
k_2_Strt = Getk(S_2(Cyc_2_Idx(1):Cyc_2_Idx(2)));

Cyc_Tem_Idx = CB(S_Tem);
k_Tem_Strt = Getk(S_Tem(Cyc_Tem_Idx(1):Cyc_Tem_Idx(2)));

%% Find Indices and offsets

Tem_1_End_Idx = Cyc_Tem_Idx(k_1_End + 1 - k_Tem_Strt + 1);
Tem_2_Strt_Idx = Cyc_Tem_Idx(k_2_Strt - k_Tem_Strt);

% Time offsets
OS_Tem = T_1(Cyc_1_Idx_end) - T_Tem(Tem_1_End_Idx);
OS_2 = (T_1(Cyc_1_Idx_end) - T_2(Cyc_2_Idx(1))) ...    
    + (T_Tem(Tem_2_Strt_Idx) - T_Tem(Tem_1_End_Idx));

% Indices
Idx_1 = 1:Cyc_1_Idx_end - 1;
Idx_Tem = Tem_1_End_Idx:Tem_2_Strt_Idx - 1;
Idx_2 = Cyc_2_Idx(1):length(T_2);


%% Concatenate data

T_Resyn = [T_1(Idx_1); T_Tem(Idx_Tem) + OS_Tem; T_2(Idx_2) + OS_2];
S_Resyn = [S_1(Idx_1); S_Tem(Idx_Tem); S_2(Idx_2)];
D_Resyn = [D_1(Idx_1); zeros([length(S_Tem(Idx_Tem)) 1]); D_2(Idx_2)];


