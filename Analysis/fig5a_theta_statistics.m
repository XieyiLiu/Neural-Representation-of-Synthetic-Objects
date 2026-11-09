% Fig. 5a: associated statistics only
% Subject-level circular/Pearson correlations; one-sample and paired t-tests.
% Test circular coefficients directly; Fisher-transform Pearson coefficients.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig5a_theta_statistics.mat'));

Nsub=numel(p1all);

th_corr = nan(Nsub,3);

r_corr  = nan(Nsub,3);

for s = 1:Nsub

    th1 = p1all{s}(:,1);  r1 = p1all{s}(:,2);
    th2 = p2all{s}(:,1);  r2 = p2all{s}(:,2);
    thp = ppvall{s}(:,1); rp = ppvall{s}(:,2);

    idx12 = find(r1>3 & r2>3);
    idx1p = find(r1>3 & rp>3);
    idx2p = find(r2>3 & rp>3);

    th_corr(s,1) = circ_corrcc(th1(idx12), th2(idx12));
    th_corr(s,2) = circ_corrcc(th1(idx1p), thp(idx1p));
    th_corr(s,3) = circ_corrcc(th2(idx2p), thp(idx2p));

    r_corr(s,1)  = corr(r1(idx12), r2(idx12), 'Rows','complete');
    r_corr(s,2)  = corr(r1(idx1p), rp(idx1p), 'Rows','complete');
    r_corr(s,3)  = corr(r2(idx2p), rp(idx2p), 'Rows','complete');
end

%% Subject summaries
mean_th = mean(th_corr,1, 'omitnan')
mean_r  = mean(r_corr, 1, 'omitnan')

nsub = sum(~isnan(th_corr),1);
sem_theta = std(th_corr,0,1,'omitnan') ./ sqrt(nsub);

fprintf('\n=== Theta SEM ===\n');
fprintf('T1T2=%.4f, T1PV=%.4f, T2PV=%.4f\n', sem_theta);

r_z  = atanh(r_corr);

[~,p_theta,ci_theta,stats_theta] = ttest(th_corr,0,'Tail','both');
theta_pair_names = {'Task1-Task2','Task1-PV','Task2-PV'};
fprintf('\n=== Seed407 theta correlations: two-sided one-sample tests ===\n');
for pair_index = 1:3
    fprintf('%s: mean r_cc=%.8f, t(%d)=%.8f, p=%.12g\n', ...
        theta_pair_names{pair_index},mean_th(pair_index),stats_theta.df(pair_index), ...
        stats_theta.tstat(pair_index),p_theta(pair_index));
end
[~,p_r]     = ttest(r_z);

p_theta
p_r

[~,p12_r] = ttest(r_z(:,1), r_z(:,2));
[~,p13_r] = ttest(r_z(:,1), r_z(:,3));
[~,p23_r] = ttest(r_z(:,2), r_z(:,3));

[~,p12_th] = ttest(th_corr(:,1), th_corr(:,2));
[~,p13_th] = ttest(th_corr(:,1), th_corr(:,3));
[~,p23_th] = ttest(th_corr(:,2), th_corr(:,3));

%% Test summaries
fprintf('\n=== Two-sided one-sample tests vs zero ===\n');
fprintf('Theta p:  T1T2=%.4g, T1PV=%.4g, T2PV=%.4g\n', p_theta);
fprintf('r p:      T1T2=%.4g, T1PV=%.4g, T2PV=%.4g\n', p_r);

fprintf('\n=== Paired comparison (t-test) ===\n');
fprintf('r:  T1T2 vs T1PV=%.4g, T1T2 vs T2PV=%.4g, T1PV vs T2PV=%.4g\n', ...
        p12_r, p13_r, p23_r);
fprintf('θ:  T1T2 vs T1PV=%.4g, T1T2 vs T2PV=%.4g, T1PV vs T2PV=%.4g\n', ...
        p12_th, p13_th, p23_th);
