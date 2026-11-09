% Shared figure helper: Compute pairwise angular differences in radians.
% By Philipp Berens, 2009. See licenses/CircStat_license.txt.
function r =  circ_dist2(x,y)

if nargin < 2
  y = x;
end

if size(x,2)>size(x,1)
  x = x';
end

if size(y,2)>size(y,1)
  y = y';
end

r = angle(repmat(exp(1i*x),1,length(y)) ...
       ./ repmat(exp(1i*y'),length(x),1));
