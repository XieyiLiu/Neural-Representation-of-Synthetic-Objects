% Fig. 3a / Supplementary Fig. 8a
% Procrustes alignment and Pearson correlations between human and macaque spaces.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig3a_object_space_comparison.mat'));

[r_pre_PC1,p_pre_PC1] = corr(double(A(:,1)), double(B(:,1)), ...
    'Type','Pearson','Tail','both');
[r_pre_PC2,p_pre_PC2] = corr(double(A(:,2)), double(B(:,2)), ...
    'Type','Pearson','Tail','both');

[d, A_aligned, ~] = procrustes( ...
    B, ...
    A);

[r_post_PC1,p_post_PC1] = corr(double(A_aligned(:,1)), double(B(:,1)), ...
    'Type','Pearson','Tail','both');
[r_post_PC2,p_post_PC2] = corr(double(A_aligned(:,2)), double(B(:,2)), ...
    'Type','Pearson','Tail','both');

correlation_statistics = table( ...
    {'Before alignment';'Before alignment';'After alignment';'After alignment'}, ...
    {'PC1';'PC2';'PC1';'PC2'}, repmat(size(A,1),4,1), ...
    [r_pre_PC1;r_pre_PC2;r_post_PC1;r_post_PC2], ...
    [p_pre_PC1;p_pre_PC2;p_post_PC1;p_post_PC2], ...
    'VariableNames',{'Stage','Component','N','PearsonR','PearsonP'});
correlation_statistics.Properties.Description = 'Two-sided Pearson correlation tests';

fprintf('=== Two-sided Pearson correlations before alignment ===\n');
fprintf('PC1: n = %d, r = %.8f, p = %.2e\n', size(A,1),r_pre_PC1,p_pre_PC1);
fprintf('PC2: n = %d, r = %.8f, p = %.2e\n\n', size(A,1),r_pre_PC2,p_pre_PC2);

fprintf('=== Fig. 3a: two-sided Pearson correlations after Procrustes alignment ===\n');
fprintf('PC1: n = %d, r = %.8f, p = %.2e\n', size(A,1),r_post_PC1,p_post_PC1);
fprintf('PC2: n = %d, r = %.8f, p = %.2e\n\n', size(A,1),r_post_PC2,p_post_PC2);

fprintf('Procrustes residual (d): %.4f\n', d);
figure;
subplot(1,2,1)
for i = 1:500
    plot(A_aligned(i,1), A_aligned(i,2),'Color',tp_interp(I(i),:),'Marker','.','MarkerSize',10,'LineStyle','none');hold on
end
xlabel('PC1');
ylabel('PC2');
axis square; box off
title('Macaque object space');

subplot(1,2,2)
set(gcf,'Position',[744,550.6,638.5999999999999,499.4])
for i = 1:500
    plot(B(i,1),B(i,2),'Color',tp_interp(I(i),:),'Marker','.','MarkerSize',10,'LineStyle','none');hold on
end
xlabel('PC1');
ylabel('PC2');
axis square; box off
title('Human object space');
