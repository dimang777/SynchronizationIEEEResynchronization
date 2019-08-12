% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.

function [Resampled] = Func_Resample2(...
    SignaltoResample_x, ...
    SignaltoResample, ...
    Resampled_x)

for ResampleCode_Condense = 1

Resampled = zeros(size(Resampled_x))';

EndValue = max(Resampled_x);
ResampleContainer = cell([ceil(EndValue/100) 1]);
Local_Shr_Time = cell([ceil(EndValue/100) 1]);
Local_Shr_Data = cell([ceil(EndValue/100) 1]);
Time_Shr_Local_RS = cell([ceil(EndValue/100) 1]);

for i = 1:ceil(EndValue/100)
display([num2str(i) '/' num2str(ceil(EndValue/100))]);

Local_Shr_Index = ((i-1)*99<SignaltoResample_x & i*101>=SignaltoResample_x); % 99 and 101 was used to avoid nan by having empty data at the end. The number of resampled data is the same.
Local_Shr_Time{i} = SignaltoResample_x(Local_Shr_Index);
Local_Shr_Data{i} = SignaltoResample(Local_Shr_Index);
Time_Shr_Local_RS{i} = Resampled_x((i-1)*100<Resampled_x & i*100>=Resampled_x);
end

for i = 1:ceil(EndValue/100) % This for loop can be turned into parfor if the resource is available

display(['for ' num2str(i) '/' num2str(ceil(EndValue/100))]);


ts_local = timeseries(Local_Shr_Data{i} ,Local_Shr_Time{i});
ts_local = setinterpmethod(ts_local, 'zoh');
Data_ts_resampled_local = resample(ts_local,Time_Shr_Local_RS{i});

ResampleContainer{i} = Data_ts_resampled_local.Data;

end

for i = 1:ceil(EndValue/100)
display([num2str(i) '/' num2str(ceil(EndValue/100))]);
Resampled((i-1)*100<Resampled_x & i*100>=Resampled_x) = ResampleContainer{i};
end

end

% Example of usage
%{
% x1 = 1/1000:1/1000:1;
% x2 = 1/1024:1/1024:1;
% 
% y1 = sin(x1);
% y2 = sin(x2);
% 
% figure(1); clf; hold on;
% plot(x1, y1)
% plot(x2, y2, 'r')
% 
% N_input = 2;
% data_input = cell([N_input 1]);
% data_input{1} = y1;
% data_input{2} = y2;
% labels_input = {'1000', '1024'};
% 
% example_panning(N_input, data_input, labels_input)
% 
% 
% % Resample
% SamplingRate = 1024;
% SignaltoResample_x = x1;
% SignaltoResample = y1;
% ResampleStartTime = 0;
% ResampleEndTime = 1;
% 
% [Resampled_x, Resampled] = Func_Resample(...
%     SamplingRate, ...
%     SignaltoResample_x, ...
%     SignaltoResample, ...
%     ResampleStartTime, ...
%     ResampleEndTime);
% 
% 
% % Plot resampled
% figure(1); clf; hold on;
% plot(Resampled_x, Resampled)
% plot(x2, y2, 'r')
% 
% N_input = 2;
% data_input = cell([N_input 1]);
% data_input{1} = Resampled;
% data_input{2} = y2;
% labels_input = {'1000', '1024'};
% 
% example_panning(N_input, data_input, labels_input)
% Now Resampled_x,Resampled (from x1,y1) and x2,y2 are exactly the same.
%}