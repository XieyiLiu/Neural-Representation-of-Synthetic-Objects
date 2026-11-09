% Supplementary Fig. 13a: direct response PCA
% Response PCA, Procrustes alignment, and Pearson correlations.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig13a_response_pca.mat'));

[d_resp, Y_align_resp, transform_resp] = procrustes( ...
    X_ref_resp, Y_mov_resp, ...
    'Scaling', false, ...
    'Reflection', false);

[r_pc1_resp, p_pc1_resp] = corr(X_ref_resp(:,1), Y_align_resp(:,1), ...
    'Rows', 'complete', ...
    'Type', 'Pearson');

[r_pc2_resp, p_pc2_resp] = corr(X_ref_resp(:,2), Y_align_resp(:,2), ...
    'Rows', 'complete', ...
    'Type', 'Pearson');

fprintf('\n===== Neural-response PCA comparison after PC2 flip + Procrustes =====\n');
fprintf('Procrustes distance = %.6f\n', d_resp);
fprintf('PC1 corr after alignment = %.4f, p = %.4g\n', ...
    r_pc1_resp, p_pc1_resp);
fprintf('PC2 corr after alignment = %.4f, p = %.4g\n', ...
    r_pc2_resp, p_pc2_resp);

%% Aligned response spaces

figure;
hold on;

h1 = plot(X_ref_resp(:,1), X_ref_resp(:,2), 'o', ...
    'Color', [0.2 0.2 0.2], ...
    'MarkerFaceColor', [0.2 0.2 0.2], ...
    'MarkerSize', 4, ...
    'LineStyle', 'none');

h2 = plot(Y_align_resp(:,1), Y_align_resp(:,2), 'o', ...
    'Color', [0.8 0.2 0.2], ...
    'MarkerFaceColor', [0.8 0.2 0.2], ...
    'MarkerSize', 4, ...
    'LineStyle', 'none');

axis square;
xlabel('PC1');
ylabel('PC2');
title('PCA space (SCT vs. PV)');

legend([h1 h2], {'PV','SCT'}, 'Location', 'best');

opt = struct();
opt.noLegend = false;
opt.figPosIn = [1 1 3.283333333333333 2.066666666666666];

applyFigureStyle(gcf, opt);

r1_resp = r_pc1_resp;
r2_resp = r_pc2_resp;
p1_resp = p_pc1_resp;
p2_resp = p_pc2_resp;

figure;
set(gcf, 'Position', [100 100 800 400]);

%% PC1 correlation
subplot(1,2,1)

plot(X_ref_resp(:,1), Y_align_resp(:,1), '.', ...
    'Color', [0.5 0.5 0.5], ...
    'MarkerSize', 12);
hold on

mn1 = min([X_ref_resp(:,1); Y_align_resp(:,1)]);
mx1 = max([X_ref_resp(:,1); Y_align_resp(:,1)]);
pad1 = 0.05 * (mx1 - mn1 + eps);
xlim1 = [mn1-pad1, mx1+pad1];
ylim1 = xlim1;

xlim(xlim1);
ylim(ylim1);

plot(xlim1, xlim1, 'k--', 'LineWidth', 1);

axis square
xlabel('PC1 (PV)');
ylabel('PC1 (SCT)');
title('PC1 comparison');

text(xlim1(1) + 0.05*range(xlim1), ...
     xlim1(2) - 0.08*range(xlim1), ...
     sprintf('r = %.3f\np = %.1e', r1_resp, p1_resp), ...
     'FontSize', 11, ...
     'FontWeight', 'bold');

%% PC2 correlation
subplot(1,2,2)

plot(X_ref_resp(:,2), Y_align_resp(:,2), '.', ...
    'Color', [0.5 0.5 0.5], ...
    'MarkerSize', 12);
hold on

mn2 = min([X_ref_resp(:,2); Y_align_resp(:,2)]);
mx2 = max([X_ref_resp(:,2); Y_align_resp(:,2)]);
pad2 = 0.05 * (mx2 - mn2 + eps);
xlim2 = [mn2-pad2, mx2+pad2];
ylim2 = xlim2;

xlim(xlim2);
ylim(ylim2);

plot(xlim2, xlim2, 'k--', 'LineWidth', 1);

axis square
xlabel('PC2 (PV)');
ylabel('PC2 (SCT)');
title('PC2 comparison');

text(xlim2(1) + 0.05*range(xlim2), ...
     xlim2(2) - 0.08*range(xlim2), ...
     sprintf('r = %.3f\np = %.1e', r2_resp, p2_resp), ...
     'FontSize', 11, ...
     'FontWeight', 'bold');
