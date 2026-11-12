% Fig. 5c: participant summaries
% Subject-level selectivity summaries and paired t-tests.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig5c_subject_comparison.mat'));

p1all_clean = cellfun(@(x) x(~any(isnan(x),2), :), ppvall, 'UniformOutput', false);
p1all_median = cellfun(@(x) median(x, 1), p1all_clean, 'UniformOutput', false);
ttpv = cell2mat(p1all_median');
median_mean(1,:) = mean(ttpv);
median_std(1,:) = std(ttpv)./sqrt(8);

p1all_clean = cellfun(@(x) x(~any(isnan(x),2), :), p1all, 'UniformOutput', false);
p1all_median = cellfun(@(x) median(x, 1), p1all_clean, 'UniformOutput', false);
tt1 = cell2mat(p1all_median');
median_mean(2,:) = mean(tt1);
median_std(2,:) = std(tt1)./sqrt(8);

p1all_clean = cellfun(@(x) x(~any(isnan(x),2), :), p2all, 'UniformOutput', false);
p1all_median = cellfun(@(x) median(x, 1), p1all_clean, 'UniformOutput', false);
tt2 = cell2mat(p1all_median');
median_mean(3,:) = mean(tt2);
median_std(3,:) = std(tt2)./sqrt(8);

fprintf(['Across-subject means of within-subject median z-scored R (n = %d): ' ...
    'Task 1 = %.2f, Task 2 = %.2f, passive viewing = %.2f.\n'], ...
    size(tt1,1), median_mean(2,2), median_mean(3,2), median_mean(1,2));

[h,p_task1_pv,ci_task1_pv,stats_task1_pv] = ttest(tt1(:,2),ttpv(:,2),'Tail','both');
[h,p_task2_pv,ci_task2_pv,stats_task2_pv] = ttest(tt2(:,2),ttpv(:,2),'Tail','both');
[h,p_task1_task2,ci_task1_task2,stats_task1_task2] = ttest(tt1(:,2),tt2(:,2),'Tail','both');
fprintf('Task1 vs PV: t(%d)=%.8f, p=%.12g\n',stats_task1_pv.df,stats_task1_pv.tstat,p_task1_pv);
fprintf('Task2 vs PV: t(%d)=%.8f, p=%.12g\n',stats_task2_pv.df,stats_task2_pv.tstat,p_task2_pv);
fprintf('Task1 vs Task2: t(%d)=%.8f, p=%.12g\n',stats_task1_task2.df,stats_task1_task2.tstat,p_task1_task2);

p = p_task1_task2; ci = ci_task1_task2; stats = stats_task1_task2;

%% Subject comparisons
figure;
set(gcf,'Position',[744,128,253.8,867])

color_PV    = [0   0   0]   / 255;
color_Task1 = [0   0   255] / 255;
color_Task2 = [255 0   0]   / 255;
color_err   = [0.6 0.6 0.6];

median_subj = [ttpv(:,2), tt1(:,2), tt2(:,2)];

point_jitter = linspace(-0.18, 0.18, size(median_subj,1))';

subplot(3,1,1)
idx = [1 2];

b = bar(median_mean(idx,2));
hold on
b.FaceColor = 'flat';
b.EdgeColor = 'none';
b.CData(1,:) = color_PV;
b.CData(2,:) = color_Task1;

errorbar(1:2, median_mean(idx,2), median_std(idx,2), ...
    'Color', color_err, 'LineStyle','none', 'LineWidth',1.5);

for k = 1:numel(idx)
    scatter(k + point_jitter, median_subj(:,idx(k)), 18, 'o', ...
        'MarkerFaceColor', 'w', ...
        'MarkerEdgeColor', b.CData(k,:), ...
        'LineWidth', 0.8, ...
        'HandleVisibility', 'off');
end
xticklabels({'PV','Task 1'})
ylabel('Median z-scored R value')
box off

ymax = max([median_mean(idx,2) + median_std(idx,2); ...
            reshape(median_subj(:,idx), [], 1)]);
y_sig = ymax * 1.15;
plot([1 1 2 2], [y_sig*0.98 y_sig y_sig y_sig*0.98], 'k', 'LineWidth',1.2)
text(1.5, y_sig*1.02, '*', 'HorizontalAlignment','center', 'FontSize',14)

subplot(3,1,2)
idx = [1 3];

b = bar(median_mean(idx,2));
hold on
b.FaceColor = 'flat';
b.EdgeColor = 'none';
b.CData(1,:) = color_PV;
b.CData(2,:) = color_Task2;

errorbar(1:2, median_mean(idx,2), median_std(idx,2), ...
    'Color', color_err, 'LineStyle','none', 'LineWidth',1.5);

for k = 1:numel(idx)
    scatter(k + point_jitter, median_subj(:,idx(k)), 18, 'o', ...
        'MarkerFaceColor', 'w', ...
        'MarkerEdgeColor', b.CData(k,:), ...
        'LineWidth', 0.8, ...
        'HandleVisibility', 'off');
end
xticklabels({'PV','Task 2'})
ylabel('Median z-scored R value')
box off

ymax = max([median_mean(idx,2) + median_std(idx,2); ...
            reshape(median_subj(:,idx), [], 1)]);
y_sig = ymax * 1.15;
plot([1 1 2 2], [y_sig*0.98 y_sig y_sig y_sig*0.98], 'k', 'LineWidth',1.2)
text(1.5, y_sig*1.02, '**', 'HorizontalAlignment','center', 'FontSize',14)

subplot(3,1,3)
idx = [2 3];

b = bar(median_mean(idx,2));
hold on
b.FaceColor = 'flat';
b.EdgeColor = 'none';
b.CData(1,:) = color_Task1;
b.CData(2,:) = color_Task2;

errorbar(1:2, median_mean(idx,2), median_std(idx,2), ...
    'Color', color_err, 'LineStyle','none', 'LineWidth',1.5);

for k = 1:numel(idx)
    scatter(k + point_jitter, median_subj(:,idx(k)), 18, 'o', ...
        'MarkerFaceColor', 'w', ...
        'MarkerEdgeColor', b.CData(k,:), ...
        'LineWidth', 0.8, ...
        'HandleVisibility', 'off');
end
xticklabels({'Task 1','Task 2'})
ylabel('Median z-scored R value')
box off
