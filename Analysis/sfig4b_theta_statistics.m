% Supplementary Fig. 4b: circular correlation between the high- and low-naming-consistency maps.
% Theta values are ordered LH then RH on the exact vertices used for the Fig. 2 theta correlation.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig4b_theta_statistics.mat'),'theta_first','theta_second','vertex_ids_lh','vertex_ids_rh');

n_lh = numel(vertex_ids_lh);
n_rh = numel(vertex_ids_rh);
assert(isequal(size(theta_first),[n_lh+n_rh,1]) && isequal(size(theta_second),size(theta_first)));
[rho,p_builtin] = circ_corrcc(theta_first,theta_second);
fprintf('Fig. 2 vertices: %d LH + %d RH = %d total\n',n_lh,n_rh,n_lh+n_rh);
fprintf('SFig. 4b naming consistency: r_cc = %.6f',rho);
if p_builtin < 0.001
    fprintf('; p < 0.001 (two-sided circular correlation test)\n');
else
    fprintf('; p = %.2e (two-sided circular correlation test)\n',p_builtin);
end
