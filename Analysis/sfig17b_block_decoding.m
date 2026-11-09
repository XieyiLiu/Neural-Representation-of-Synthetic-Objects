% Supplementary Fig. 17b
% Compare frontal/parietal and VTC decoding using two-sided paired t-tests.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig17b_block_decoding.mat'));

figure;
resultall_mean =squeeze(mean(resultall,2));
resultctl_mean =squeeze(mean(resultctl,2));
resultall50 = squeeze(resultall(50,:,:));
%% Paired regional comparisons

[~,p_frontal_vtc,~,stats_frontal_vtc] = ttest(resultall50(:,1),resultall50(:,3),'Tail','both');
[~,p_parietal_vtc,~,stats_parietal_vtc] = ttest(resultall50(:,2),resultall50(:,3),'Tail','both');

sfig17b_roi_names = {'Frontal'; 'Parietal'; 'VTC'};
sfig17b_n_subjects = size(resultall50,1);
sfig17b_mean_accuracy = mean(resultall50,1)';
sfig17b_sem_accuracy = std(resultall50,0,1)' / sqrt(sfig17b_n_subjects);
sfig17b_decoding_summary = table(sfig17b_roi_names, ...
    repmat(sfig17b_n_subjects,3,1), sfig17b_mean_accuracy, sfig17b_sem_accuracy, ...
    'VariableNames', {'ROI','N','MeanAccuracy','SEM'});
sfig17b_paired_stats = table({'Frontal-VTC'; 'Parietal-VTC'}, ...
    sfig17b_mean_accuracy(1:2), repmat(sfig17b_mean_accuracy(3),2,1), ...
    mean(resultall50(:,1:2)-resultall50(:,3),1)', ...
    [stats_frontal_vtc.tstat; stats_parietal_vtc.tstat], ...
    [stats_frontal_vtc.df; stats_parietal_vtc.df], ...
    [p_frontal_vtc; p_parietal_vtc], ...
    'VariableNames', {'Comparison','MeanA','MeanB','MeanDifference','T','DF','P'});

fprintf('\n=== Supplementary Fig. 17b | Block-design task decoding ===\n');
fprintf('Task1 vs. Task2; 50 PCs; n = %d subjects.\n',sfig17b_n_subjects);
fprintf('\nMean classification accuracy +/- s.e.m. across subjects:\n');
for report_roi = 1:height(sfig17b_decoding_summary)
    fprintf('  %s: %.2f%% +/- %.2f%%\n', ...
        sfig17b_decoding_summary.ROI{report_roi}, ...
        100*sfig17b_decoding_summary.MeanAccuracy(report_roi), ...
        100*sfig17b_decoding_summary.SEM(report_roi));
end
fprintf('\nManuscript comparisons: two-sided paired t-tests; uncorrected p values.\n');
for report_comparison = 1:height(sfig17b_paired_stats)
    fprintf('  %s: t(%d) = %.2f, p = %.3g\n', ...
        sfig17b_paired_stats.Comparison{report_comparison}, ...
        sfig17b_paired_stats.DF(report_comparison), ...
        sfig17b_paired_stats.T(report_comparison), ...
        sfig17b_paired_stats.P(report_comparison));
end

cc = [246  83  20;
      255 187   0;
        0 161 241] / 255;

for bb = 1:length(allROI)
    bar(bb, resultall_mean(50,bb), 'FaceColor', cc(bb,:), 'EdgeColor','none'); hold on
    err = std(resultall(50,:,bb)') / sqrt(length(subjall));
    errorbar(bb, resultall_mean(50,bb), err, ...
        'LineStyle','none', 'LineWidth',1.5, 'Color',[0.5 0.5 0.5]); hold on

    ysub = resultall50(:,bb);
    xsub = bb + linspace(-0.18,0.18,numel(ysub))';

    scatter(xsub, ysub, 20, ...
        'MarkerFaceColor','white', ...
        'MarkerEdgeColor',cc(bb,:), ...
        'LineWidth',0.8);

end

ylim([0.5 1])
ylabel('Classification accuracy');
set(gca,'XTick',1:length(allROI), 'XTickLabel', sfig17b_roi_names);

opt = struct();
opt.fontName  = 'Arial';
opt.axFont    = 8.5;
opt.labFont   = 8.5;
opt.legFont   = 7.5;
opt.titleFont = 9.5;
opt.axisLineWidth = 0.75;
opt.noLegend  = true;
opt.figPosIn  = [1 1 3.2 2.4];

applyFigureStyle(gcf, opt);
