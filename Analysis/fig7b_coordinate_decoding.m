% Fig. 7b
% One-sided task and two-sided task-PV permutation comparisons with add-one correction.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig7b_coordinate_decoding.mat'));

tasks  = {'task1','task2','pv'};
axesId = [1 2];
Nsub   = 8;

dirSign = [+1, -1];

ROIs = {'frontal4','parietal2','LOC2'};
roiTitles = {'Frontal','Parietal','VTC'};
cor_foldername = {'glasser2','glasser3','glasser2'};

fig = figure('Color', 'w');
set(fig,'Position',[60,80,1500,485])
axHandles = gobjects(1, numel(ROIs));
lgd = gobjects(1);

for rr = 1:numel(ROIs)
    ROI = ROIs{rr};

    corrall = nan(9, Nsub);

    %% Image-label permutation tests
    p_pair_img(1).p12 = nan; p_pair_img(1).p13 = nan; p_pair_img(1).p23 = nan;
    p_pair_img(2).p12 = nan; p_pair_img(2).p13 = nan; p_pair_img(2).p23 = nan;

    chanceMean = nan(numel(axesId), numel(tasks));
    chanceP95  = nan(numel(axesId), numel(tasks));

    for a = 1:numel(axesId)
        ax = axesId(a);

Nperm=size(permutation_by_roi,1);
ttPerm=permutation_by_roi(:,:,:,a,rr);
real=real_by_roi(:,:,a,rr);
        dsub12 = real(:,1) - real(:,2);
        dsub13 = real(:,1) - real(:,3);
        dsub23 = real(:,2) - real(:,3);

        d12 = mean(dsub12);
        d13 = mean(dsub13);
        d23 = mean(dsub23);

        null12 = squeeze(mean(ttPerm(:,:,1) - ttPerm(:,:,2), 2));
        null13 = squeeze(mean(ttPerm(:,:,1) - ttPerm(:,:,3), 2));
        null23 = squeeze(mean(ttPerm(:,:,2) - ttPerm(:,:,3), 2));

        sgn = dirSign(a);
        p12_oneS_img = (sum(sgn*null12 >= sgn*d12) + 1) / (Nperm + 1);
        p13_twoS_img = (sum(abs(null13) >= abs(d13)) + 1) / (Nperm + 1);
        p23_twoS_img = (sum(abs(null23) >= abs(d23)) + 1) / (Nperm + 1);

        p_pair_img(a).p12 = p12_oneS_img;
        p_pair_img(a).p13 = p13_twoS_img;
        p_pair_img(a).p23 = p23_twoS_img;

        fprintf('[%s] Axis%d  p(T1-T2)=%.6g (one-sided, dirSign=%+d) | p(T1-PV)=%.6g | p(T2-PV)=%.6g\n', ...
            roiTitles{rr}, ax, p12_oneS_img, sgn, p13_twoS_img, p23_twoS_img);

        for t = 1:numel(tasks)
            nullMean_t = squeeze(mean(ttPerm(:,:,t), 2));
            chanceMean(a,t) = mean(nullMean_t, 'omitnan');
            chanceP95(a,t) = prctile(nullMean_t, 95);
        end

        rowBase = (a-1)*3;
        for t = 1:3
            corrall(rowBase+t, :) = real(:,t).';
        end
    end

    %% Decoding summaries

    axHandles(rr) = subplot(1, numel(ROIs), rr);
    hold(axHandles(rr), 'on');

    corrmean = mean(corrall, 2, 'omitnan');
    eb = nan(9,1);
    for t = 1:9
        eb(t) = std(corrall(t,:), 0, 'omitnan') / sqrt(Nsub);
    end

    xt = [2 3 4  6 7 8];
    datanum = [1 2 3  4 5 6];

    cc = { [28 143 255]/255, [204 92 92]/255, 'k',  [28 143 255]/255, [204 92 92]/255, 'k' };

    barWidth    = 0.8;
    barAlpha    = 1;
    chanceGrey  = [0.5 0.5 0.5];

    barH = gobjects(1,3);

    for tt = 1:numel(xt)
        br = bar(xt(tt), corrmean(datanum(tt)), 'EdgeColor','none', 'BarWidth',barWidth);
        br.FaceColor = cc{tt};
        br.FaceAlpha = barAlpha;

        if tt <= 3
            br.DisplayName = switchTaskName(tasks{tt});
            barH(tt) = br;
        else
            br.HandleVisibility = 'off';
        end

        errorbar(xt(tt), corrmean(datanum(tt)), eb(datanum(tt)), '.', ...
            'LineWidth',1.5, 'Color',[0.5 0.5 0.5], ...
            'HandleVisibility','off');

        scatter(xt(tt) + linspace(-0.3,0.3,Nsub)*barWidth, ...
            corrall(datanum(tt),:), 20, 'o', 'MarkerEdgeColor',br.FaceColor, ...
            'MarkerFaceColor','w', 'LineWidth',1, 'HandleVisibility','off');
    end

    set(gca,'XTick',[mean(xt(1:3)), mean(xt(4:6))], ...
        'XTickLabel',{'Axis 1','Axis 2'}, ...
        'FontName','Ariel','FontSize',12,'FontWeight','bold');

    ylabel('Correlation');
    set(gca,'FontName','Tahoma','FontSize',12,'FontWeight','bold');
    box off
    axis([1 9 -0.1 1.08])

    title(roiTitles{rr}, ...
        'Interpreter','none','FontName','Tahoma','FontSize',12,'FontWeight','bold');

    %% Null references

    hNullMean = gobjects(1);
    hNullP95 = gobjects(1);
    for t = 1:3
        showInLegend = rr == numel(ROIs) && t == 1;
        [hMeanTmp, hP95Tmp] = drawNullLines(xt(t), chanceMean(1,t), ...
            chanceP95(1,t), barWidth, chanceGrey, showInLegend);
        if showInLegend
            hNullMean = hMeanTmp;
            hNullP95 = hP95Tmp;
        end
        drawNullLines(xt(3+t), chanceMean(2,t), chanceP95(2,t), ...
            barWidth, chanceGrey, false);
    end

    if rr == numel(ROIs)
        lgd = legend([barH hNullP95 hNullMean], ...
            {'Task 1','Task 2','PV','Chance (95th percentile)','Chance (mean)'}, ...
            'Location','none', 'FontName','Tahoma', ...
            'FontSize',10,'FontWeight','bold');
        legend boxoff
    end

    yr = diff(ylim);
    dy = 0.04 * yr;

    if strcmp(ROI,'LOC2') == 0

        xA1   = xt(1:3);
        idxA1 = datanum(1:3);
        yA1   = max(corrall(idxA1,:),[],'all','omitnan');
        yA1   = yA1 + dy;

        addSigFlat(xA1(1), xA1(2), yA1 + dy*1.0, p_pair_img(1).p12);
        addSigFlat(xA1(1), xA1(3), yA1 + dy*4.0, p_pair_img(1).p13);
        addSigFlat(xA1(2), xA1(3), yA1 + dy*2.5, p_pair_img(1).p23);

        xA2   = xt(4:6);
        idxA2 = datanum(4:6);
        yA2   = max(corrall(idxA2,:),[],'all','omitnan');
        yA2   = yA2 + dy;

        addSigFlat(xA2(1), xA2(2), yA2 + dy*1.0, p_pair_img(2).p12);
        addSigFlat(xA2(1), xA2(3), yA2 + dy*4.0, p_pair_img(2).p13);
        addSigFlat(xA2(2), xA2(3), yA2 + dy*2.5, p_pair_img(2).p23);
    end

end

axesPositions = [ ...
    0.07 0.18 0.18 0.66; ...
    0.32 0.18 0.18 0.66; ...
    0.57 0.18 0.18 0.66];
for rr = 1:numel(axHandles)
    set(axHandles(rr), 'Position', axesPositions(rr,:));
end
set(lgd, 'Units', 'normalized', 'Position', [0.78 0.30 0.21 0.42]);

drawnow;
