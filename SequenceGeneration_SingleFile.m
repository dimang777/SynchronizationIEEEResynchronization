% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
n = 6;
VoltScale = 0.5;
MaxNum = 720;

for k = 1:MaxNum
    Reg = false([n 1]);
    s = 1;
    DACOutput = 0;
    pause(2);
    
    for i = 1:n

        while k > factorial(n-i)
            s = s + 1;
            k = k - factorial(n-i);
        end

        for j = 1:n
            if j <= s && Reg(j)
                s = s + 1;
            end
        end
    
        Reg(s) = true;
    
        DACOutput = VoltScale*s;
        pause(2);
    end
end
