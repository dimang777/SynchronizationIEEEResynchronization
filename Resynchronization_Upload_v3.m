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
%% Find k

CB1 = CB(S_1); 
k_1_Last = Find_k(CB1, length(CB1)-1, S_1);

CB2 = CB(S_2); 
k_2_1st = Find_k(CB2, 1, S_2);


%% Find correction offset

T_Gap = (k_2_1st - k_1_Last - 1)*(n+1)*Step_Length; % 14s cycle

OS_2 = T_1(CB1(end-1)) + T_Gap - T_2(CB2(1));

%% Concatenate data

T_Resyn = [T_1; T_2 + OS_2];
S_Resyn = [S_1; S_2];
D_Resyn = [D_1; D_2];
