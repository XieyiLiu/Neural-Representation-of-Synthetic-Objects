% Shared figure helper: Compute the circular median in radians.
% By Philipp Berens, 2009. See licenses/CircStat_license.txt.
function med = circ_median(alpha,dim)

if nargin < 2
  dim = 1;
end

M = size(alpha);
med = NaN(M(3-dim),1);
for i=1:M(3-dim)
  if dim == 2
    beta = alpha(i,:)';
  elseif dim ==1
    beta = alpha(:,i);
  else
    error('circ_median only works along first two dimensions')
  end

  beta = mod(beta,2*pi);
  n = size(beta,1);

  dd = circ_dist2(beta,beta);
  m1 = sum(dd>=0,1);
  m2 = sum(dd<=0,1);

  dm = abs(m1-m2);
  if mod(n,2)==1
    [m idx] = min(dm);
  else
    m = min(dm);
    idx = find(dm==m,2);
  end

  if m > 1
    warning('Ties detected.') %#ok<WNTAG>
  end

  md = circ_mean(beta(idx));

  if abs(circ_dist(circ_mean(beta),md)) > abs(circ_dist(circ_mean(beta),md+pi))
    md = mod(md+pi,2*pi);
  end

  med(i) = md;
end

if dim == 2
  med = med';
end
