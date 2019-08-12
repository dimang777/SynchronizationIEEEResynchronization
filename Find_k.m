% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
% k_result: rank
% Cycles_Idx: Cycle boundaries from CB function
% i: index of boundary (i to i+1 are used)
% Sync: Sync signal

function k_result = Find_k(Cycles_Idx, i, Sync)

n = 6; % Number of digits used to generate permutations
MaxPermNum = factorial(6); % Maximum number of permutations

Permutation = ReturnSeq(Cycles_Idx, i, Sync);

for k_ = 1:MaxPermNum
Sequence = GenSingleSeq(n, k_);
if isequal(Permutation, Sequence)
    k_result = k_;
    break;
end
end
