% Supplementary Fig. 11d
% Summarize split-half/cross-task correlations and subject-level t-tests.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig11d_split_half_correlations.mat'));

sfig11d_n_repetitions = size(corrall,3);
sfig11d_n_subjects = size(corrall,2);

corrall_cross = mean(corrall_cross,3);
cross_vals = mean(corrall_cross,2);

errort = std(corrall_cross') / sqrt(8);

corrall = mean(corrall,3);
split_vals = mean(corrall,2);
error_spilt = std(corrall')./sqrt(8);

cross_data = [cross_vals(1),cross_vals(2);cross_vals(1),cross_vals(3);cross_vals(2),cross_vals(3)];
errorcross = std(corrall_cross')./sqrt(8);
errorcross_data = [errorcross(1),errorcross(2);errorcross(1),errorcross(3);errorcross(2),errorcross(3)];
error_data = [errort(1),errort(2);errort(1),errort(3);errort(2),errort(3)];

dat = [cross_data,split_vals]';
err = [errorcross_data, error_spilt']';

%% Correlation summaries
figure;
set(gcf,'Position',[100,100,760,420])
h = bar(dat','grouped');
hold on
box off

% Each cross-task pair has the same color in all three reference groups.
pairColors = [29 32 135; 3 110 183; 44 177 221; 217 51 51]/255;
barPairs = [1 2 4; 1 3 4; 2 3 4];
for series = 1:3
    h(series).FaceColor = 'flat';
    h(series).CData = pairColors(barPairs(:,series),:);
end

h(1).EdgeColor = 'none';
h(2).EdgeColor = 'none';
h(3).EdgeColor = 'none';

set(gca,'XTick',1:3,'XTickLabel',{'Task 1','Task 2','PV'})
ylabel('Correlation')
ylim([0 1])
legendKeys = gobjects(1,4);
for k = 1:4
    legendKeys(k) = patch(nan,nan,pairColors(k,:),'EdgeColor','none');
end
legend(legendKeys,{'Task 1 - Task 2','Task 1 - PV','Task 2 - PV','Split half'}, ...
    'Location','eastoutside','AutoUpdate','off');
legend box off
hold on
title('Cross-task and split-half correlations')

x = nan(2, size(dat,2));
for i = 1:3
    x(i,:) = h(i).XEndPoints;
end
grayColor = [0.5 0.5 0.5];

errorbar(x(1,:), dat(1,:), err(1,:).', ...
    'Color',grayColor, 'LineStyle','none', ...
    'LineWidth',1.5, 'CapSize',6,'HandleVisibility','off');

errorbar(x(2,:), dat(2,:), err(2,:).', ...
    'Color',grayColor, 'LineStyle','none', ...
    'LineWidth',1.5, 'CapSize',6,'HandleVisibility','off');

errorbar(x(3,:), dat(3,:), err(3,:).', ...
    'Color',grayColor, 'LineStyle','none', ...
    'LineWidth',1.5, 'CapSize',6,'HandleVisibility','off');

crossIndex = [1 2;
              1 3;
              2 3];

offset = linspace(-0.08,0.08,size(corrall,2));

for gg = 1:3
    ysub = [corrall_cross(crossIndex(gg,1),:);
            corrall_cross(crossIndex(gg,2),:);
            corrall(gg,:)];

    for bb = 1:3
        scatter(x(bb,gg) + offset, ysub(bb,:), 18, ...
            'MarkerFaceColor','white', ...
            'MarkerEdgeColor',pairColors(barPairs(gg,bb),:), ...
            'LineWidth',0.8, ...
            'HandleVisibility','off');
    end
end

%% Manuscript statistics

sfig11d_test_results = zeros(9,3);
[~,p,~,test_stats] = ttest(corrall_cross(1,:),corrall(1,:),'Tail','both');
sfig11d_test_results(1,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(2,:),corrall(1,:),'Tail','both');
sfig11d_test_results(2,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(1,:),corrall(2,:),'Tail','both');
sfig11d_test_results(3,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(3,:),corrall(2,:),'Tail','both');
sfig11d_test_results(4,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(2,:),corrall(3,:),'Tail','both');
sfig11d_test_results(5,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(3,:),corrall(3,:),'Tail','both');
sfig11d_test_results(6,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(1,:),corrall_cross(2,:),'Tail','both');
sfig11d_test_results(7,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(1,:),corrall_cross(3,:),'Tail','both');
sfig11d_test_results(8,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross(2,:),corrall_cross(3,:),'Tail','both');
sfig11d_test_results(9,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];

sfig11d_all_stats = table( ...
    {'Task1-Task2'; 'Task1-PV'; 'Task1-Task2'; 'Task2-PV'; 'Task1-PV'; 'Task2-PV'; 'Task1-Task2'; 'Task1-Task2'; 'Task1-PV'}, ...
    {'Task1 split-half'; 'Task1 split-half'; 'Task2 split-half'; 'Task2 split-half'; 'PV split-half'; 'PV split-half'; 'Task1-PV'; 'Task2-PV'; 'Task2-PV'}, ...
    double(mean(corrall_cross([1 2 1 3 2 3 1 1 2],:),2)), ...
    double([mean(corrall([1 1 2 2 3 3],:),2); mean(corrall_cross([2 3 3],:),2)]), ...
    sfig11d_test_results(:,1), sfig11d_test_results(:,2), sfig11d_test_results(:,3), ...
    'VariableNames', {'ComparisonA','ComparisonB','MeanA','MeanB','T','DF','P'});
sfig11d_manuscript_stats = sfig11d_all_stats([1 3 2 4],:);
sfig11d_additional_stats = sfig11d_all_stats(5:9,:);

fprintf('\n=== Supplementary Fig. 11d | Pearson correlations ===\n');
fprintf('Average each subject across %d split-half repetitions, then compare %d subjects.\n', ...
    sfig11d_n_repetitions, sfig11d_n_subjects);
fprintf('Two-sided paired t-tests; p values are uncorrected; t uses A minus B.\n');
for report_row = 1:height(sfig11d_manuscript_stats)
    if report_row == 1
        fprintf('\n1. Task1-Task2 correlation vs. each active-task split-half\n');
    elseif report_row == 3
        fprintf('\n2. Active-task-PV correlations vs. active-task split-half\n');
    end
    fprintf('  %s vs. %s: mean r = %.2f vs. %.2f; t(%d) = %.2f, p = %.3g\n', ...
        sfig11d_manuscript_stats.ComparisonA{report_row}, ...
        sfig11d_manuscript_stats.ComparisonB{report_row}, ...
        sfig11d_manuscript_stats.MeanA(report_row), sfig11d_manuscript_stats.MeanB(report_row), ...
        sfig11d_manuscript_stats.DF(report_row), sfig11d_manuscript_stats.T(report_row), ...
        sfig11d_manuscript_stats.P(report_row));
end
