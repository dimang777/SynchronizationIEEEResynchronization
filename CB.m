% Isaac Sung Jae Chang 22-Jan-2019.
% Last Revision: 22-Jan-2019.
function Idx = CB(S)
Idx = find(diff(0.1>S) == 1)+1;
