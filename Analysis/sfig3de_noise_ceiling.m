% Supplementary Fig. 3d-e: fMRI and electrophysiology noise ceilings.
% Spearman-Brown noise ceilings and Deming fits for fMRI and electrophysiology.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig3de_noise_ceiling.mat'));

%% fMRI noise ceiling
x_f = r_sh(isfinite(r_all_fmri));
y_f = r_all_fmri(:);

stats_fmri = fit_noiseceiling_curve_deming(2*x_f./(1+x_f), y_f, 'fMRI');

%% Electrophysiology noise ceiling
x_e = x_e(:);
y_e = r_all_ephys(:);

assert(numel(x_e)==numel(y_e), '横纵轴单元数量不一致');

x_e_sb = 2*x_e./(1+x_e);

good = valid_response & isfinite(x_e_sb) & isfinite(y_e);

stats_ephys = fit_noiseceiling_curve_deming( ...
    x_e_sb(good), y_e(good), 'Ephys');

xlabel('Split-half reliability');
ylabel('Object space model performance (r)');

fprintf('\n=== Supplementary Fig. 3d/e: two-sided Pearson correlation tests ===\n');
noise_ceiling_statistics = [stats_fmri,stats_ephys];
panel_labels = {'SFig. 3d (fMRI)','SFig. 3e (Ephys)'};
for report_index = 1:numel(noise_ceiling_statistics)
    result = noise_ceiling_statistics(report_index);
    if result.pearson_p == 0
        p_text = 'p < 0.001 (MATLAB numerical underflow; not an exact zero)';
    else
        p_text = sprintf('p = %.2e',result.pearson_p);
    end
    fprintf('%s: N = %d, slope = %.8f, r = %.8f, %s\n', ...
        panel_labels{report_index},result.N,result.a,result.pearson_r,p_text);
end
