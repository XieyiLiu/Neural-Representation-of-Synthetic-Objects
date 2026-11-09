% Shared figure helper: Compute circular-circular correlation and a two-sided analytical p-value.
% By Philipp Berens, 2009. See licenses/CircStat_license.txt.
function [rho,pval] = circ_corrcc(alpha1,alpha2)

if size(alpha1,2) > size(alpha1,1)
	alpha1 = alpha1';
end

if size(alpha2,2) > size(alpha2,1)
	alpha2 = alpha2';
end

if length(alpha1)~=length(alpha2)
  error('Input dimensions do not match.')
end

n = length(alpha1);
alpha1_bar = circ_mean(alpha1);
alpha2_bar = circ_mean(alpha2);

num = sum(sin(alpha1 - alpha1_bar) .* sin(alpha2 - alpha2_bar));
den = sqrt(sum(sin(alpha1 - alpha1_bar).^2) .* sum(sin(alpha2 - alpha2_bar).^2));
rho = num / den;

l20 = mean(sin(alpha1 - alpha1_bar).^2);
l02 = mean(sin(alpha2 - alpha2_bar).^2);
l22 = mean((sin(alpha1 - alpha1_bar).^2) .* (sin(alpha2 - alpha2_bar).^2));

ts = sqrt((n * l20 * l02)/l22) * rho;
pval = 2 * (1 - normcdf(abs(ts)));
