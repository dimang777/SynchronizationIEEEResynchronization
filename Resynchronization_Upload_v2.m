% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
% Variables
% D_1 % Signal 1 data
% S_1 % Synchronization signal of Signal 1
% T_1 % Time variable of Signal 1
% D_2 % Signal 2 data
% S_2 % Synchronization signal of Signal 2
% T_2 % Time variable of Signal 2

n = 6;
VoltScale = 0.5;
MaxNum = 720; % 6!
Step_length = 2; % 2 seconds
Fs = 1000;
%% Get k

Cyc_1_Idx = CB(S_1); 
k_1_End = Getk(S_1(Cyc_1_Idx(end-1):Cyc_1_Idx(end)));

Cyc_2_Idx = CB(S_2); 
k_2_Strt = Getk(S_2(Cyc_2_Idx(1):Cyc_2_Idx(2)));


%% Find correction offset

T_gap = (k_2_Strt - (k_1_End + 1))*(n+1)*Step_Length;
T_2_Start = T_1(Cyc_1_Idx(end-1)) + T_gap;

OS_2 = -T_2(Cyc_2_Idx(1)) + T_2_Start;

%% Concatenate data

T_Resyn = [T_1; T_2 + OS_2];
S_Resyn = [S_1; S_2];
D_Resyn = [D_1; D_2];
