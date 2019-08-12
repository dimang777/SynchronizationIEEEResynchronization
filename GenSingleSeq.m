% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
function Seq = GenSingleSeq(n, k)

Reg = false([n 1]);
Seq = zeros([n 1]);

for i = n:-1:1
    s = 1;
    while k > factorial(i-1)
        s = s + 1;
        k = k - factorial(i-1);
    end
    
    for j = 1:n
        if j <= s && Reg(j)
            s = s + 1;
        end
    end
    
    Reg(s) = true;
    Seq(n-i+1) = s;
    
end
end