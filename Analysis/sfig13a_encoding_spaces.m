% Supplementary Fig. 13a: encoding-based spaces
% Procrustes alignment and Pearson correlations between encoding-based spaces.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig13a_encoding_spaces.mat'));

[d_objspace, Y_align, transform_objspace] = procrustes( ...
    X_ref, Y_mov, ...
    'Scaling', false, ...
    'Reflection', false);

[r_pc1_objspace, p_pc1_objspace] = corr(double(X_ref(:,1)), double(Y_align(:,1)), ...
    'Rows', 'complete', ...
    'Type', 'Pearson');

[r_pc2_objspace, p_pc2_objspace] = corr(double(X_ref(:,2)), double(Y_align(:,2)), ...
    'Rows', 'complete', ...
    'Type', 'Pearson');

fprintf('\n===== Object-space comparison after Procrustes =====\n');
fprintf('Procrustes distance = %.6f\n', d_objspace);
fprintf('PC1 corr after alignment = %.4f, p = %.4g\n', ...
    r_pc1_objspace, p_pc1_objspace);
fprintf('PC2 corr after alignment = %.4f, p = %.4g\n', ...
    r_pc2_objspace, p_pc2_objspace);

%% Aligned spaces

figure;
hold on;

h1 = plot(X_ref(:,1), X_ref(:,2), 'o', ...
    'Color', [0.2 0.2 0.2], ...
    'MarkerFaceColor', [0.2 0.2 0.2], ...
    'MarkerSize', 4, ...
    'LineStyle', 'none');

h2 = plot(Y_align(:,1), Y_align(:,2), 'o', ...
    'Color', [0.8 0.2 0.2], ...
    'MarkerFaceColor', [0.8 0.2 0.2], ...
    'MarkerSize', 4, ...
    'LineStyle', 'none');

axis square;
xlabel('PC1');
ylabel('PC2');
title('Object space (SCT vs. PV)');

legend([h1 h2], {'PV','SCT'}, 'Location', 'best');

opt = struct();
opt.noLegend = false;
opt.figPosIn = [1 1 3.283333333333333 2.066666666666666];

applyFigureStyle(gcf, opt);

r1 = r_pc1_objspace;
r2 = r_pc2_objspace;
p1 = p_pc1_objspace;
p2 = p_pc2_objspace;

figure;
set(gcf, 'Position', [100 100 800 400]);

%% PC1 correlation
subplot(1,2,1)

plot(X_ref(:,1), Y_align(:,1), '.', ...
    'Color', [0.5 0.5 0.5], ...
    'MarkerSize', 12);
hold on

mn1 = min([X_ref(:,1); Y_align(:,1)]);
mx1 = max([X_ref(:,1); Y_align(:,1)]);
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
     sprintf('r = %.3f\np = %.1e', r1, p1), ...
     'FontSize', 11, ...
     'FontWeight', 'bold');

%% PC2 correlation
subplot(1,2,2)

plot(X_ref(:,2), Y_align(:,2), '.', ...
    'Color', [0.5 0.5 0.5], ...
    'MarkerSize', 12);
hold on

mn2 = min([X_ref(:,2); Y_align(:,2)]);
mx2 = max([X_ref(:,2); Y_align(:,2)]);
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
     sprintf('r = %.3f\np = %.1e', r2, p2), ...
     'FontSize', 11, ...
     'FontWeight', 'bold');
