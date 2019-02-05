function k = Find_k(Cycles_Idx, k, Time, Sync, n, MaxPermNum)

Permutation = ReturnSeq(Cycles_Idx, k, Time, Sync);

for k_ = 1:MaxPermNum
Sequence = GenSingleSeq(n, k_);
if isequal(Permutation, Sequence)
    k = k_;
    break;
end
end
