% Supplementary Fig. 15b
% Spearman model correlations and Bonferroni-corrected one-sample/paired t-tests.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig15b_model_comparison.mat'));

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

rdmall(:,:,1) =  frephys100;
figure;
set(gcf,'Position',[100,100,900,560]);

h = bar(corrsub');
set(h, 'EdgeColor', 'none');
hold on;
noiseCeilPlot = [lowerCeilSub(:); lowerCeilMean];
draw_subject_noise_ceiling(noiseCeilPlot);

red1 = [1.0 0.6 0.6];
red2 = [0.95 0.3 0.3];
red3 = [0.80 0.10 0.10];
blue1 = [0.60 0.78 0.90];
blue2   = [0.27 0.51 0.71];
blue3  = [0.10 0.28 0.45];
grey  = [0.5 0.5 0.5];
deep_purple  = [0.36 0.20 0.50];
light_purple = [0.74 0.62 0.84];
deep_pink    = [0.78 0.22 0.42];
light_pink   = [0.94 0.64 0.74];

h(1).FaceColor = grey;
h(2).FaceColor = deep_purple;
h(3).FaceColor = light_purple;
h(4).FaceColor = deep_pink;
h(5).FaceColor = light_pink;
h(6).FaceColor = blue3;
h(7).FaceColor = blue2;
h(8).FaceColor = blue1;

set(gca, 'XTick', 1:9, 'XTickLabel', [subject_ids, {'Mean'}]);

title('Task 1');
xlabel('Subjects');
ylabel('Correlation');
ylim([-0.15 0.70]);

legend(h,{'Macaque IT','Odd-one-out task','Image categorization task','Object space','AlexNet','Semantic (MPNet)','Semantic (BERT)','Semantic (fastText)'}, ...
        'Location','northoutside','NumColumns',3,'AutoUpdate','off');
legend('boxoff')
box off;
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
end
