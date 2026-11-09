% Fig. 6f
% Real-object Fisher-z paired model comparisons with Bonferroni correction.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig6f_real_model_significance.mat'));

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
%% Pairwise model comparisons

nModel = 5;
zsub = atanh(corrsub(:,1:5));

p_list = [];
idx_list = [];

for i = 1:nModel-1
    for j = i+1:nModel
        [~, p] = ttest(zsub(i,1:5), zsub(j,1:5));
        p_list(end+1,1) = p; %#ok<SAGROW>
        idx_list(end+1,:) = [i j]; %#ok<SAGROW>
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
set(gcf,'Color','w','Position',[120,120,820,680]);

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
       'TickLabels',{'n.s.','p_{bonf}<0.05','p_{bonf}<0.01','p_{bonf}<0.001'});
ylabel(cb, 'Significance (Bonferroni-corrected)');

model_names = { ...
    'Macaque IT', ...
    'AlexNet', ...
    'Semantic (MPNet)', ...
    'Semantic (BERT)', ...
    'Semantic (fastText)'};

set(gca,'XTick',1:nModel,'XTickLabel',model_names, ...
        'XTickLabelRotation',45, 'FontSize',10);

set(gca,'YTick',1:nModel,'YTickLabel',fliplr(model_names));

title('Pairwise significance matrix (Bonferroni-corrected)');

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
    xText = numel(noiseCeilByGroup) + 0.35;
    text(xText, noiseCeilByGroup(end), 'noise ceiling', ...
        'Color', lineColor, 'FontSize', 10, 'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'left', 'Clipping', 'off');
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
