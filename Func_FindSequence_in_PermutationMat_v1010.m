% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.

% Revisions
% v1.010 - Uses PermuMat that only has the permutations and no other
% information such as order, time, and index
% v1.000
function [SequenceFound, Index_in_PermutationMat] = ...
    Func_FindSequence_in_PermutationMat_v1010(PermutationMat_DAQ, Sequence)

[~, loc] = intersect(PermutationMat_DAQ,Sequence(:)','rows');
if isempty(loc)
    SequenceFound = false;
    Index_in_PermutationMat = -1;
else
    SequenceFound = true;
    Index_in_PermutationMat = loc;
end

    

