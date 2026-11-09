% Supplementary Fig. 2a: naming-consistency distributions.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig2a_naming_distributions.mat'));

% Same permutation settings as Fig. 1d and the manuscript Methods.
rng(407,'twister');
figure;
set(gcf,'Position',[500,300,564.2,450]); hold on;

%% Naming-consistency distributions
v_real   = meanvec_mpnet_real(:);
v_fake   = meanvec_mpnet_fake(:);
v_random = RDM_straighten(corr_randomeng_mpnet);
nbins = 70;
edges = linspace(-1, 1, nbins+1);
binCenters = (edges(1:end-1) + edges(2:end)) / 2;
c_real   = [46 92 143]/255;
c_fake   = [166 46 38]/255;
c_random = [0.50 0.50 0.50];
h1 = histogram(v_real,   edges, 'Normalization','probability', ...
    'FaceColor',c_real,   'FaceAlpha',0.22, 'EdgeColor','none');
h2 = histogram(v_fake,   edges, 'Normalization','probability', ...
    'FaceColor',c_fake,   'FaceAlpha',0.22, 'EdgeColor','none');
h3 = histogram(v_random, edges, 'Normalization','probability', ...
    'FaceColor',c_random, 'FaceAlpha',0.22, 'EdgeColor','none');
p_real   = h1.Values;
p_fake   = h2.Values;
p_random = h3.Values;
smooth_win = 8;
p_real_s   = smoothdata(p_real,   'gaussian', smooth_win);
p_fake_s   = smoothdata(p_fake,   'gaussian', smooth_win);
p_random_s = smoothdata(p_random, 'gaussian', smooth_win);
plot(binCenters, p_real_s,   'Color',c_real,   'LineWidth',2.5);
plot(binCenters, p_fake_s,   'Color',c_fake,   'LineWidth',2.5);
plot(binCenters, p_random_s, 'Color',c_random, 'LineWidth',2.5);
m_real   = median(v_real);
m_fake   = median(v_fake);
m_random = median(v_random);
fprintf('[Naming consistency] Medians: real = %.6f, synthetic = %.6f, word set = %.6f\n', ...
    m_real, m_fake, m_random);
ylim_now = ylim;
plot([m_real m_real],     ylim_now, '--', 'Color',c_real,   'LineWidth',1);
plot([m_fake m_fake],     ylim_now, '--', 'Color',c_fake,   'LineWidth',1);
plot([m_random m_random], ylim_now, '--', 'Color',c_random, 'LineWidth',1);
xlabel('Word correlation value');
ylabel('Probability');
xlim([-0.1 1]);
box off;
set(gca,'FontSize',11);
legend([h1 h2 h3], {'100 real images','100 synthetic images','Word set (1,266 nouns)'}, ...
       'Location','northeast', 'Color','white', 'EdgeColor','none', 'AutoUpdate','off');

%% Two-sided median-difference tests (add-one correction)
nPerm = 1000;
fprintf('[Permutation] Two-sided median-difference tests, %d permutations, add-one correction.\n', nPerm);
x1 = v_real(:);
y1 = v_fake(:);
x1 = x1(~isnan(x1));
y1 = y1(~isnan(y1));
[Tobs_rf, p_rf, ci_rf] = local_permtest_medianDiff(x1, y1, nPerm);
fprintf('[Permutation] Real vs Synthetic:   Tobs = median(real)-median(synthetic) = %.6f, p = %.6g, perm[2.5%% 97.5%%]=[%.6f %.6f]\n', ...
    Tobs_rf, p_rf, ci_rf(1), ci_rf(2));
x2 = v_fake(:);
y2 = v_random(:);
x2 = x2(~isnan(x2));
y2 = y2(~isnan(y2));
[Tobs_fr, p_fr, ci_fr] = local_permtest_medianDiff(x2, y2, nPerm);
fprintf('[Permutation] Synthetic vs Random: Tobs = median(synthetic)-median(random) = %.6f, p = %.6g, perm[2.5%% 97.5%%]=[%.6f %.6f]\n', ...
    Tobs_fr, p_fr, ci_fr(1), ci_fr(2));
