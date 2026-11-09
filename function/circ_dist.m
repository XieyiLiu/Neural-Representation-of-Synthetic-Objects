% Shared figure helper: Compute element-wise angular differences in radians.
% By Philipp Berens, 2009. See licenses/CircStat_license.txt.
function r =  circ_dist(x,y)

if size(x,1)~=size(y,1) && size(x,2)~=size(y,2) && length(y)~=1
  error('Input dimensions do not match.')
end

r = angle(exp(1i*x)./exp(1i*y));
