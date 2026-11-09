% Supplementary Fig. 11c
% Summarize split-half/cross-task slopes and subject-level t-tests.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig11c_split_half_slopes.mat'));

sfig11c_n_repetitions = size(corrall_slope,3);
sfig11c_n_subjects = size(corrall_slope,2);

corrall_cross_slope = mean(corrall_cross_slope,3);
cross_vals_slope = mean(corrall_cross_slope,2);

corrall_slope = mean(corrall_slope,3);
split_vals = mean(corrall_slope,2);
error_spilt = std(corrall_slope')./sqrt(8);

cross_data = [cross_vals_slope(1),cross_vals_slope(4);cross_vals_slope(2),cross_vals_slope(6);cross_vals_slope(3),cross_vals_slope(5)];
errorcross_slope = std(corrall_cross_slope')./sqrt(8);
errorcross_data = [errorcross_slope(1),errorcross_slope(4);errorcross_slope(2),errorcross_slope(6);errorcross_slope(3),errorcross_slope(5)];

dat = [cross_data,split_vals]';
err = [errorcross_data, error_spilt']';

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
ylabel('Slope')
title('Cross-task and split-half slopes')
ylim([0 1.6])
legendKeys = gobjects(1,4);
for k = 1:4
    legendKeys(k) = patch(nan,nan,pairColors(k,:),'EdgeColor','none');
end
legend(legendKeys,{'Task 1 - Task 2','Task 1 - PV','Task 2 - PV','Split half'}, ...
    'Location','eastoutside','AutoUpdate','off');
legend box off
hold on

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

crossIndex = [1 4;
              2 6;
              3 5];

offset = linspace(-0.08,0.08,size(corrall_slope,2));

for gg = 1:3
    ysub = [corrall_cross_slope(crossIndex(gg,1),:);
            corrall_cross_slope(crossIndex(gg,2),:);
            corrall_slope(gg,:)];

    for bb = 1:3
        scatter(x(bb,gg) + offset, ysub(bb,:), 18, ...
            'MarkerFaceColor','white', ...
            'MarkerEdgeColor',pairColors(barPairs(gg,bb),:), ...
            'LineWidth',0.8, ...
            'HandleVisibility','off');
    end
end

%% Manuscript statistics

sfig11c_test_results = zeros(9,3);
[~,p,~,test_stats] = ttest(corrall_cross_slope(1,:),corrall_slope(1,:),'Tail','both');
sfig11c_test_results(1,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(4,:),corrall_slope(1,:),'Tail','both');
sfig11c_test_results(2,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(2,:),corrall_slope(2,:),'Tail','both');
sfig11c_test_results(3,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(6,:),corrall_slope(2,:),'Tail','both');
sfig11c_test_results(4,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(3,:),corrall_slope(3,:),'Tail','both');
sfig11c_test_results(5,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(5,:),corrall_slope(3,:),'Tail','both');
sfig11c_test_results(6,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(1,:),corrall_cross_slope(2,:),'Tail','both');
sfig11c_test_results(7,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(1,:),corrall_cross_slope(3,:),'Tail','both');
sfig11c_test_results(8,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];
[~,p,~,test_stats] = ttest(corrall_cross_slope(2,:),corrall_cross_slope(3,:),'Tail','both');
sfig11c_test_results(9,:) = [double(test_stats.tstat),double(test_stats.df),double(p)];

sfig11c_all_stats = table( ...
    {'Task1 -> Task2'; 'Task1 -> PV'; 'Task2 -> Task1'; 'Task2 -> PV'; 'PV -> Task1'; 'PV -> Task2'; 'Task1 -> Task2'; 'Task1 -> Task2'; 'Task2 -> Task1'}, ...
    {'Task1 split-half'; 'Task1 split-half'; 'Task2 split-half'; 'Task2 split-half'; 'PV split-half'; 'PV split-half'; 'Task2 -> Task1'; 'PV -> Task1'; 'PV -> Task1'}, ...
    double(mean(corrall_cross_slope([1 4 2 6 3 5 1 1 2],:),2)), ...
    double([mean(corrall_slope([1 1 2 2 3 3],:),2); mean(corrall_cross_slope([2 3 3],:),2)]), ...
    sfig11c_test_results(:,1), sfig11c_test_results(:,2), sfig11c_test_results(:,3), ...
    'VariableNames', {'ComparisonA','ComparisonB','MeanA','MeanB','T','DF','P'});
sfig11c_manuscript_stats = sfig11c_all_stats([2 4 1 3],:);
sfig11c_additional_stats = sfig11c_all_stats(5:9,:);

fprintf('\n=== Supplementary Fig. 11c | Linear-fit slopes ===\n');
fprintf('Average each subject across %d split-half repetitions, then compare %d subjects.\n', ...
    sfig11c_n_repetitions, sfig11c_n_subjects);
fprintf('Two-sided paired t-tests; p values are uncorrected; t uses A minus B.\n');
fprintf('Slope X -> Y: X is the reference (x axis); Y is the response (y axis).\n');
for report_row = 1:height(sfig11c_manuscript_stats)
    if report_row == 1
        fprintf('\n1. Active-task-to-PV slopes vs. active-task split-half\n');
    elseif report_row == 3
        fprintf('\n2. Task1-Task2 slopes vs. active-task split-half\n');
    end
    fprintf('  %s vs. %s: mean slope = %.2f vs. %.2f; t(%d) = %.2f, p = %.3g\n', ...
        sfig11c_manuscript_stats.ComparisonA{report_row}, ...
        sfig11c_manuscript_stats.ComparisonB{report_row}, ...
        sfig11c_manuscript_stats.MeanA(report_row), sfig11c_manuscript_stats.MeanB(report_row), ...
        sfig11c_manuscript_stats.DF(report_row), sfig11c_manuscript_stats.T(report_row), ...
        sfig11c_manuscript_stats.P(report_row));
end
