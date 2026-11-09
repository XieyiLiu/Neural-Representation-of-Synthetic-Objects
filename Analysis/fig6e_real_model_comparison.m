% Fig. 6e
% Real-object Spearman RDM correlations and Bonferroni-corrected one-sample t-tests.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig6e_real_model_comparison.mat'));

clear corrsub
for i = 1:5
    corrsub(1,i) = corr(RDM_straighten(frephys100),RDM_straighten(corrbeta(:,:,i)),'type','Spearman');
    corrsub(2,i) = corr(RDM_straighten(corrresp),RDM_straighten(corrbeta(:,:,i)),'type','Spearman');
    corrsub(3,i) = corr(RDM_straighten(corrcoef(meanvec_mpnet_real')),RDM_straighten(corrbeta(:,:,i)),'type','Spearman');
    corrsub(4,i) = corr(RDM_straighten(corrcoef(meanvec_bert_real')),RDM_straighten(corrbeta(:,:,i)),'type','Spearman');
    corrsub(5,i) = corr(RDM_straighten(sm_8fmrivec_word2vec),RDM_straighten(corrbeta(:,:,i)),'type','Spearman');
end

corrsub = [corrsub,mean(corrsub,2)];

lowerCeilSub = lower_noise_ceiling(corrbeta, false);
lowerCeilMean = mean(lowerCeilSub, 'omitnan');

p_raw = nan(1,5);
tval  = nan(1,5);
for i = 1:5
    [~, p_raw(i), ~, stats] = ttest(corrsub(i,1:5), 0, 'Tail', 'right');
    tval(i) = stats.tstat;
end

m = 5;
p_bonf = min(p_raw * m, 1)
h_bonf = p_bonf < 0.05;

figure;
set(gcf,'Color','w','Position',[100,100,900,560]);

h = bar(corrsub');
set(h, 'EdgeColor', 'none');
hold on;

light_pink   = [0.94 0.64 0.74];
grey  = [0.5 0.5 0.5];
blue1 = [0.60 0.78 0.90];
blue2   = [0.27 0.51 0.71];
blue3  = [0.10 0.28 0.45];

h(1).FaceColor = grey;
h(2).FaceColor = light_pink;
h(3).FaceColor = blue3;
h(4).FaceColor = blue2;
h(5).FaceColor = blue1;

draw_subject_noise_ceiling([lowerCeilSub; lowerCeilMean]);

set(gca, 'XTick', 1:6, 'XTickLabel', {'S1','S2','S3','S4','S5','Mean'});

title('100 real objects');
xlabel('Subjects');
ylabel('Correlation');
ylim([0 0.72]);

legend(h,{'Macaque IT','AlexNet','Semantic (MPNet)','Semantic (BERT)','Semantic (fastText)'}, ...
        'Location','northoutside','NumColumns',3,'AutoUpdate','off');
legend('boxoff')
box off;

function rdm_straighten = RDM_straighten(rdm_matrix)
count = 2;
rdm_straighten = [];
for i =1:length(rdm_matrix)-1
    rdm_straighten = [rdm_straighten;rdm_matrix(count:length(rdm_matrix),i)];
    count = count+1;
end
end

function draw_subject_noise_ceiling(noiseCeilByGroup)
    lineColor = [0.50 0.50 0.50];
    xHalfWidth = 0.38;
    for x = 1:numel(noiseCeilByGroup)
        y = noiseCeilByGroup(x);
        plot([x-xHalfWidth, x+xHalfWidth], [y, y], '--', ...
            'Color', lineColor, 'LineWidth', 1.2, 'HandleVisibility', 'off');
    end
end

function lowerCeil = lower_noise_ceiling(brainRDMs, invertSimilarity)
    nSub = size(brainRDMs, 3);
    lowerCeil = nan(nSub,1);
    for s = 1:nSub
        others = setdiff(1:nSub, s);
        groupRDM = mean(brainRDMs(:,:,others), 3, 'omitnan');
        subjVec = rdm_vec(brainRDMs(:,:,s), invertSimilarity);
        groupVec = rdm_vec(groupRDM, invertSimilarity);
        lowerCeil(s) = corr(subjVec, groupVec, 'type', 'Spearman', 'rows', 'complete');
    end
end

function v = rdm_vec(mat, invertSimilarity)
    if nargin > 1 && invertSimilarity
        mat = 1 - mat;
    end
    mask = tril(true(size(mat,1)), -1);
    v = double(mat(mask));
end
