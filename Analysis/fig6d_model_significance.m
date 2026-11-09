% Fig. 6d
% Fisher-z paired model comparisons and Bonferroni-corrected significance maps.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig6d_model_significance.mat'));

clear corrsub

lowerCeilSub = lower_noise_ceiling(rb_fake);
lowerCeilMean = mean(lowerCeilSub, 'omitnan');
for i = 1:8
    corrsub(1,i) = corr(RDM_straighten(1-frephys100),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
    corrsub(2,i) = corr(RDM_straighten(1-online_psy),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
    corrsub(3,i) = corr(RDM_straighten(1-bh(:,:,i)),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
    corrsub(4,i) = corr(RDM_straighten(1-picSm2),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
    corrsub(5,i) = corr(RDM_straighten(1-alexnet_corr),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
    corrsub(6,i) = corr(RDM_straighten(1-sm_8fmrivec_mpnet(:,:,i)),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
    corrsub(7,i) = corr(RDM_straighten(1-sm_8fmrivec_bert(:,:,i)),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
    corrsub(8,i) = corr(RDM_straighten(1-sm_8fmrivec_word2vec(:,:,i)),RDM_straighten(1-rb_fake(:,:,i)),'type','Spearman');
end
corrsub = [corrsub,mean(corrsub,2)];
pcorr = zeros(2,8);
for i = 1:8
    [r, p] = partialcorr(RDM_straighten(sm_8fmrivec_mpnet(:,:,i)), RDM_straighten(rb_fake(:,:,i)), RDM_straighten(alexnet_corr));
    pcorr(1,i) = r;
    [r, p] = partialcorr(RDM_straighten(alexnet_corr), RDM_straighten(rb_fake(:,:,i)),RDM_straighten(sm_8fmrivec_mpnet(:,:,i)));
    pcorr(2,i) = r;
end

p_raw = nan(1,8);
tval  = nan(1,8);

for i = 1:8
    [~, p_raw(i), ~, stats] = ttest(corrsub(i,1:8), 0, 'Tail', 'right');
    tval(i) = stats.tstat;
end

m = 8;
p_bonf = min(p_raw * m, 1);
min(p_bonf(6:8))
h_bonf = p_bonf < 0.05;

%% Model-versus-VTC statistics

vs_zero_model_names = {'macaque IT','Odd-one-out task','Image categorization task', ...
    'Object space','AlexNet','Personal semantic (MPNet)', ...
    'Personal semantic (BERT)','Personal semantic (fastText)'};
vs_zero_n = sum(~isnan(corrsub(:,1:8)),2);
model_vs_zero_stats = table(vs_zero_model_names(:),corrsub(:,9),vs_zero_n, ...
    vs_zero_n-1,tval(:),p_raw(:),p_bonf(:), ...
    'VariableNames',{'Model','MeanSpearmanR','N','DF','T','P_raw','P_Bonferroni'});
behavior_vtc_stats = model_vs_zero_stats([3 2],:);
semantic_vtc_stats = model_vs_zero_stats(6:8,:);
fprintf('\n=== Fig. 6 manuscript statistics: model versus VTC ===\n');
fprintf('One-sided one-sample t-tests against zero; raw subject-level Spearman r; Bonferroni across 8 models.\n');
fprintf('Behavioral models (group mean correlations):\n');
for report_index = 1:height(behavior_vtc_stats)
    fprintf('  %s-VTC: mean r = %.8f (%.2f), n = %d, t(%d) = %.8f, p_raw = %.12g, p_Bonferroni = %.12g\n', ...
        behavior_vtc_stats.Model{report_index},behavior_vtc_stats.MeanSpearmanR(report_index), ...
        behavior_vtc_stats.MeanSpearmanR(report_index),behavior_vtc_stats.N(report_index), ...
        behavior_vtc_stats.DF(report_index),behavior_vtc_stats.T(report_index), ...
        behavior_vtc_stats.P_raw(report_index),behavior_vtc_stats.P_Bonferroni(report_index));
end
fprintf('Subject-specific semantic models (group mean correlations):\n');
for report_index = 1:height(semantic_vtc_stats)
    fprintf('  %s-VTC: mean r = %.8f, n = %d, t(%d) = %.8f, p_raw = %.12g, p_Bonferroni = %.12g\n', ...
        semantic_vtc_stats.Model{report_index},semantic_vtc_stats.MeanSpearmanR(report_index), ...
        semantic_vtc_stats.N(report_index),semantic_vtc_stats.DF(report_index), ...
        semantic_vtc_stats.T(report_index),semantic_vtc_stats.P_raw(report_index), ...
        semantic_vtc_stats.P_Bonferroni(report_index));
end
fprintf('Behavior summary: maximum Bonferroni p = %.12g\n',max(behavior_vtc_stats.P_Bonferroni));
fprintf('Semantic summary: maximum group mean r = %.8f; minimum Bonferroni p = %.12g\n', ...
    max(semantic_vtc_stats.MeanSpearmanR),min(semantic_vtc_stats.P_Bonferroni));
fprintf('=== End Fig. 6 manuscript statistics ===\n\n');

%% Behavioral RDM agreement

[behavior_rdm_rho,behavior_rdm_p] = corr(RDM_straighten(online_psy), ...
    RDM_straighten(mean(bh,3)),'type','Spearman','Tail','both');
behavior_rdm_stats = struct('rho',behavior_rdm_rho,'p',behavior_rdm_p, ...
    'n_image_pairs',numel(RDM_straighten(online_psy)), ...
    'n_categorization_subjects',size(bh,3),'type','Spearman','tail','two-sided');
fprintf('=== Agreement between behavioral RDMs ===\n');
fprintf('Odd-one-out vs mean categorization RDM: Spearman r = %.12f (%.2f), n_pairs = %d\n', ...
    behavior_rdm_rho,behavior_rdm_rho,behavior_rdm_stats.n_image_pairs);
if behavior_rdm_p==0
    fprintf('Two-sided Spearman test: p < 0.001 (MATLAB returned 0 at numerical precision; not an exact zero).\n');
else
    fprintf('Two-sided Spearman test: p = %.12g\n',behavior_rdm_p);
end
fprintf('=== End behavioral RDM agreement ===\n\n');

rdmall(:,:,1) =  frephys100;
%% Pairwise model comparisons

nModel = 8;
zsub = atanh(corrsub(:,1:8));

p_list = [];
idx_list = [];

for i = 1:nModel-1
    for j = i+1:nModel
        [~, p] = ttest(zsub(i,1:8), zsub(j,1:8));
        p_list(end+1,1) = p;
        idx_list(end+1,:) = [i j];
    end
end

m = numel(p_list);

p_bonf_list = min(p_list * m, 1);

p_bonf_mat = ones(nModel, nModel);
for k = 1:numel(p_bonf_list)
    i = idx_list(k,1);
    j = idx_list(k,2);
    p_bonf_mat(i,j) = p_bonf_list(k);
    p_bonf_mat(j,i) = p_bonf_list(k);
end

mask_upper = triu(true(nModel));

level_mat = nan(nModel, nModel);

level_mat(p_bonf_mat >= 0.05)                               = 0;
level_mat(p_bonf_mat < 0.05  & p_bonf_mat >= 0.01)          = 1;
level_mat(p_bonf_mat < 0.01  & p_bonf_mat >= 0.001)         = 2;
level_mat(p_bonf_mat < 0.001)                               = 3;

level_disp = level_mat;
level_disp(mask_upper) = NaN;

level_disp_plot = flipud(level_disp);

%% Significance matrix

figure;
set(gcf,'Position',[520,300,560,520]);

hImg = imagesc(level_disp_plot);
axis square;
box off;
set(gca,'YDir','normal');
hold on;

set(gca,'Color',[1 1 1]);
set(hImg,'AlphaData',~isnan(level_disp_plot));

sig_cmap = [ ...
    0.98 0.92 0.92;
    0.95 0.70 0.70;
    0.85 0.40 0.40;
    0.60 0.10 0.10];
colormap(sig_cmap);

caxis([-0.5 3.5]);

cb = colorbar;
set(cb,'Ticks',[0 1 2 3], ...
       'TickLabels',{'n.s.','p_{Bonf}<0.05','p_{Bonf}<0.01','p_{Bonf}<0.001'});
ylabel(cb, 'Significance (Bonferroni-corrected)');

model_names = { ...
    'Macaque IT', ...
    'Odd-one-out task', ...
    'Image categorization task', ...
    'Object space', ...
    'AlexNet', ...
    'Semantic (MPNet)', ...
    'Semantic (BERT)', ...
    'Semantic (fastText)'};

set(gca,'XTick',1:nModel,'XTickLabel',model_names, ...
        'XTickLabelRotation',45, 'FontSize',10);

set(gca,'YTick',1:nModel,'YTickLabel',fliplr(model_names));

title(sprintf('Pairwise significance matrix (Bonferroni-corrected, m=%d)', m));

for i = 2:nModel
    for j = 1:i-1
        pB = p_bonf_mat(i,j);

        if pB < 0.001
            txt = '***';
        elseif pB < 0.01
            txt = '**';
        elseif pB < 0.05
            txt = '*';
        else
            txt = '';
        end

        if ~isempty(txt)
            text(j, nModel - i + 1, txt, ...
                'HorizontalAlignment','center', ...
                'FontSize',12, ...
                'FontWeight','bold', ...
                'Color','w');
        end
    end
end

function lowerCeil = lower_noise_ceiling(brainRDMs)
    nSub = size(brainRDMs, 3);
    lowerCeil = nan(nSub, 1);
    for s = 1:nSub
        others = setdiff(1:nSub, s);
        groupRDM = mean(brainRDMs(:,:,others), 3, 'omitnan');
        subjVec = RDM_straighten(1 - brainRDMs(:,:,s));
        groupVec = RDM_straighten(1 - groupRDM);
        lowerCeil(s) = corr(subjVec, groupVec, 'type', 'Spearman');
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
    text(numel(noiseCeilByGroup) + 0.42, noiseCeilByGroup(end), 'noise ceiling', ...
        'Color', lineColor, 'FontSize', 10, 'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'left', 'Clipping', 'off');
end
