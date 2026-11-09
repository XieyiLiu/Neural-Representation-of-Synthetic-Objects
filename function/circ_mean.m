% Shared figure helper: Compute the weighted circular mean in radians.
% By Philipp Berens, 2009. See licenses/CircStat_license.txt.
function [mu ul ll] = circ_mean(alpha, w, dim)

if nargin < 3
  dim = 1;
end

if nargin < 2 || isempty(w)

	w = ones(size(alpha));
else
  if size(w,2) ~= size(alpha,2) || size(w,1) ~= size(alpha,1)
    error('Input dimensions do not match');
  end
end

r = sum(w.*exp(1i*alpha),dim);

mu = angle(r);

if nargout > 1
  t = circ_confmean(alpha,0.05,w,[],dim);
  ul = mu + t;
  ll = mu - t;
end
