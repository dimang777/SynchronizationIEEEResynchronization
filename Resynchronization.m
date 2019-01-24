% Here Signal 1 is the signal recorded first before the device shutdown
% Signal 2 is the recording after the shutdown. It is assumed that some
% amount of data between the first and the second recording are missing
% This code re-aligns Signal 2 with the help of Signal Template.
% Signal template is a synchronization signal that has the missing
% synchronization information between Signal 1 and Signal 2. The template
% signal can be either previously recorded, intact synchronization signal
% with the same sampling frequency (e.g., synchronization signal of another
% trial), OR it can be a synchronization signal recorded by another device.
% In the latter case, the signal should be resampled to match the sampling
% frequency as Signal 1 and Signal 2. It is highly recommended to use the
% template that has as high sampling frequency as the signals to be fixed
% in order to achieve an optimal performance and signal re-alignment.
clear;
close all;

load('Resynchronization.mat');

% Variables
% Data_1 % Signal 1 data
% Sync_1 % Synchronization signal of Signal 1
% Time_1 % Time variable of Signal 1
% Data_2 % Signal 2 data
% Sync_2 % Synchronization signal of Signal 2
% Time_2 % Time variable of Signal 2
% Sync_Template % Template synchronization signal
% Time_Template % Time variable of the template synchronization signal
% Data_Verify % Data for validation at the end
% Time_Verify % Time variable for the validation data

load('PermutationMatrix.mat');

% Variables
% PermutationMatrix % Permutation matrix that contains the permutations in order

%% Signal 1


% Each cycle is 14s long. Therefore the minimum distance is set to 13.5s.
MinimunDistance = 13.5;

% Find the boundary of each cycle - Find the first zero point of each
% cycle PLUS the first zero point of the incomplete cycle at the end
[~, Cycle_Boundaries_Signal1_Idx] = Func_GetCycleBoundaries(Time_1 ,Sync_1, MinimunDistance); 

Sync_Signal1_Cycle_T_End = Time_1(Cycle_Boundaries_Signal1_Idx(end-1):Cycle_Boundaries_Signal1_Idx(end));
Sync_Signal1_Cycle_End = Sync_1(Cycle_Boundaries_Signal1_Idx(end-1):Cycle_Boundaries_Signal1_Idx(end));

% Find the steps of the first cycle
[Signal_Cycle_Signal1_End_StepLocations_T] = Func_GetStepLocations(Sync_Signal1_Cycle_T_End, Sync_Signal1_Cycle_End);

% Decompose the sequence to find the corresponding permutation
Permu_Sig1_Last = Func_DecomposeSequence_Cycle(...
    Sync_Signal1_Cycle_T_End, Sync_Signal1_Cycle_End, Signal_Cycle_Signal1_End_StepLocations_T);

% Index of the start of the last and incomplete cycle that gives the time when used on
% Time_1
Signal1_EndnIncomplete_Permu_Idx = Cycle_Boundaries_Signal1_Idx(end);

%% Signal 2

% Find the boundary of each cycle
MinimunDistance = 13.5;
[~, Cycle_Boundaries_Signal2_Idx] = Func_GetCycleBoundaries(Time_2 ,Sync_2, MinimunDistance); % Minimum 13.5s of interval between each cycle

Sync_Signal2_Cycle_T_Start = Time_2(Cycle_Boundaries_Signal2_Idx(1):Cycle_Boundaries_Signal2_Idx(2));
Sync_Signal2_Cycle_Start = Sync_2(Cycle_Boundaries_Signal2_Idx(1):Cycle_Boundaries_Signal2_Idx(2));

% Find the steps of the first cycle
[Signal_Cycle_Signal2_Start_StepLocations_T] = Func_GetStepLocations(Sync_Signal2_Cycle_T_Start, Sync_Signal2_Cycle_Start);

% Decompose the sequence to find permutation
Permu_Sig2_First = Func_DecomposeSequence_Cycle(...
    Sync_Signal2_Cycle_T_Start, Sync_Signal2_Cycle_Start, Signal_Cycle_Signal2_Start_StepLocations_T);

Signal2_Start_Permu_T_Idx = Cycle_Boundaries_Signal2_Idx(1);

%% Template

% Find the boundary of each cycle
MinimunDistance = 13.5;
[~, Cycle_Boundaries_Template_Indices] = Func_GetCycleBoundaries(Time_Template ,Sync_Template, MinimunDistance); % Minimum 13.5s of interval between each cycle

Sync_Template_Cycle_T_Start = Time_Template(Cycle_Boundaries_Template_Indices(1):Cycle_Boundaries_Template_Indices(2));
Sync_Template_Cycle_Start = Sync_Template(Cycle_Boundaries_Template_Indices(1):Cycle_Boundaries_Template_Indices(2));

% Find the steps of the first cycle
[Signal_Cycle_Template_Start_StepLocations_T] = Func_GetStepLocations(Sync_Template_Cycle_T_Start, Sync_Template_Cycle_Start);

% Decompose the sequence to find permutation
CycleSequence_Template_Start = Func_DecomposeSequence_Cycle(...
    Sync_Template_Cycle_T_Start, Sync_Template_Cycle_Start, Signal_Cycle_Template_Start_StepLocations_T);

% Generate permutation matrix for the signal
Permutation_Template_Start_index = dsearchn(PermutationMatrix, CycleSequence_Template_Start(:)');

% Create matrix
PermutationMat_Template = PermutationMatrix(Permutation_Template_Start_index:Permutation_Template_Start_index+length(Cycle_Boundaries_Template_Indices(:))-1, :);


figure(2); clf;
plot(Time_Template ,Sync_Template)


%% Concatenate time variable

[~, Index_in_Template_Signal1End] = ...
    Func_FindSequence_in_PermutationMat_v1010(PermutationMat_Template, Permu_Sig1_Last);

[~, Index_in_Template_Signal2Start] = ...
    Func_FindSequence_in_PermutationMat_v1010(PermutationMat_Template, Permu_Sig2_First);

Sig1_End = Time_1(Signal1_EndnIncomplete_Permu_Idx);
Sig2_Start = Time_2(Signal2_Start_Permu_T_Idx);

Temp_Sig1_End = Time_Template(Cycle_Boundaries_Template_Indices(Index_in_Template_Signal1End+1)); 
Temp_Sig2_Start = Time_Template(Cycle_Boundaries_Template_Indices(Index_in_Template_Signal2Start));

% Offsets
Offset_Temp = Sig1_End - Temp_Sig1_End;
Offset_Sig2 = (Sig1_End - Sig2_Start) ...    
    + (Temp_Sig2_Start - Temp_Sig1_End);

% Indices
Index_Sig1 = 1:Signal1_EndnIncomplete_Permu_Idx-1;
Index_Temp = Cycle_Boundaries_Template_Indices(Index_in_Template_Signal1End+1):Cycle_Boundaries_Template_Indices(Index_in_Template_Signal2Start)-1;
Index_Sig2 = Signal2_Start_Permu_T_Idx:length(Time_2);

% Segments
Segment_Sig1 = Time_1(Index_Sig1);
Segment_Temp = Time_Template(Index_Temp) + Offset_Temp;
Segment_Sig2 = Time_2(Index_Sig2) + Offset_Sig2;

Time_Resynced = [Segment_Sig1; ...
    Segment_Temp; ...
    Segment_Sig2];

% Explanation for each segment
% Template fills the missing segment between the first and the second
% recording. Indices are created so that the same procedure can be made to
% the data.

%% Concatenate data

Sync_Resynced = [Sync_1(Index_Sig1); ...
    Sync_Template(Index_Temp); ...
    Sync_2(Index_Sig2)];

Data_Resynced = [Data_1(Index_Sig1); ...
    zeros([length(Sync_Template(Index_Temp)) 1]); ...
    Data_2(Index_Sig2)];


%% Final result

f1 = figure(1); clf; hold on;

set(f1,'visible','off');
set(f1,'position',[50 50 400 600]);
NumofSubplots = 4;
Offset = 1.5;

i = 1;
ax{i} = subplot(NumofSubplots, 1, i); hold on;
plot(Time_1 ,Sync_1, 'b')
plot(Time_1 ,Data_1 - Offset, 'b')
title('Signal 1');
xlim(ax{i}, [2550 2850])
ylim(ax{i}, [-3 3.5])

i = i + 1;
ax{i} = subplot(NumofSubplots, 1, i); hold on;
plot(Time_2 ,Sync_2, 'r')
plot(Time_2 ,Data_2 - Offset, 'r')
title('Signal 2');
xlim(ax{i}, [0 300])
ylim(ax{i}, [-3 3.5])

i = i + 1;
ax{i} = subplot(NumofSubplots, 1, i:i+1); hold on;
plot(Time_Resynced, Sync_Resynced, 'k')
plot(Segment_Sig1, Sync_1(Index_Sig1), 'b')
plot(Segment_Temp, Sync_Template(Index_Temp), 'k')
plot(Segment_Sig2, Sync_2(Index_Sig2), 'r')

plot(Time_Resynced, Data_Resynced - Offset, 'k')
plot(Segment_Sig1, Data_1(Index_Sig1) - Offset, 'b')
plot(Segment_Temp, zeros([length(Sync_Template(Index_Temp)) 1]) - Offset, 'k')
plot(Segment_Sig2, Data_2(Index_Sig2) - Offset, 'r')

plot(Time_Verify ,Data_Verify - Offset - 1.5, 'k')

text(2555, -0.3, 'Re-synchronized signal')
text(2555, -4.2, 'Original signal')

title('Synchronized Signal');
ylim(ax{i}, [-4.5 3.5])
cellfun(@(x) set(x,'YTickLabel',[]),ax)

set(f1,'visible','on');

saveas(gcf, 'BfrAfr_Synchronization.jpg');
saveas(gcf, 'BfrAfr_Synchronization.emf');

