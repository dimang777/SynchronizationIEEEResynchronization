n = 6;
VoltScale = 0.5;

MaxPermNum = 1;
for i = 1:n
    MaxPermNum = MaxPermNum*i;
end

for k = 1:MaxPermNum
    Sequence = GetSequence(n, k);
    DACOutput = 0;
    pause(2);
    for i = 1:n
        DACOutput = VoltScale*Sequence(i);
        pause(2);
    end
end

