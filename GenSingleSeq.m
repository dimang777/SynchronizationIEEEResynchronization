function Sequence = GenSingleSeq(n, k)

Register = false([n 1]);
Sequence = zeros([n 1]);

Helper = ones([n 1]);
for i = 2:n
    Helper(i) = Helper(i-1)*(i-1); % e.g., 1 1 2 6 24 120 for n = 6
end

for i = n:-1:1
    s = 1;
    while k > Helper(i)
        s = s + 1;
        k = k - Helper(i);
    end
    
    for j = 1:n
        if j <= s && Register(j)
            s = s + 1;
        end
    end
    
    Register(s) = true;
    Sequence(n-i+1) = s;
    
end
end