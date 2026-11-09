% Shared figure helper: Compute mean resultant length with optional weights and bin correction.
% By Philipp Berens, 2009. See licenses/CircStat_license.txt.
function r = circ_r(alpha, w, d, dim)

if nargin < 4
  dim = 1;
end

if nargin < 2 || isempty(w)

	w = ones(size(alpha));
else
  if size(w,2) ~= size(alpha,2) || size(w,1) ~= size(alpha,1)
    error('Input dimensions do not match');
  end
end

if nargin < 3 || isempty(d)

  d = 0;
end

r = sum(w.*exp(1i*alpha),dim);

r = abs(r)./sum(w,dim);

if d ~= 0
  c = d/2/sin(d/2);
  r = c*r;
end
