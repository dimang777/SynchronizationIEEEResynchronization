% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
function k = Getk(Cycle)
n = 6;
VoltScale = 0.5;
Step_length = 2; % 2 seconds
Fs = 1000;

SignalCycle = Cycle./VoltScale;

Permutation = zeros([n 1]);

for i = 1:n
t = round((0.5+i)*Step_length*Fs)-4;
Permutation(i) = round(mean(SignalCycle(t:t+10)));
end

rank = 1;

for i = 1:n
    count = 0;
    for j = i + 1:n
    if Permutation(j) < Permutation(i)
        count = count + 1;
    end
    end
    
    rank = rank + count * ((factorial(n)*factorial(n-i))/factorial(n));
end
    
k = rank;
