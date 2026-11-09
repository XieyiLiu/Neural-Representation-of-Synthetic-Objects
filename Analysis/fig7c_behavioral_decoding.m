% Fig. 7c
% One-sided task and two-sided control permutation comparisons with add-one correction.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig7c_behavioral_decoding.mat'));

Nsub   = 8;
axesId = [1 2];
dirSign = [+1, -1];

ROIs = {'frontal4','parietal2','LOC2'};
roiTitles = {'Frontal','Parietal','VTC'};
cor_foldername = {'glasser2','glasser3','glasser2'};

filePattern_task = '%s_%s_axis%d_bhv.mat';
filePattern_ctrl = '%s_pv_control_bhv.mat';

fig = figure('Color', 'w');
set(fig,'Position',[8.2,452.2,1860,360])
axHandles = gobjects(1, numel(ROIs));
lgd = gobjects(1);

xt          = [2 3  5 6  8];
barWidth    = 0.8;
barAlpha    = 1;
chanceGrey  = [0.5 0.5 0.5];

cTask1 = [0 0 0.8];
cTask2 = [0.7 0.13 0.13];
cPV    = [0 0 0];

for rr = 1:numel(ROIs)
    ROI = ROIs{rr};

real5=real_by_roi(:,:,rr);
ttPerm=permutation_by_roi(:,:,:,rr);Nperm=size(ttPerm,1);
    chanceMean = nan(1,5);
    chanceP95  = nan(1,5);
    for b = 1:5
        nullMean_b   = squeeze(mean(ttPerm(:,:,b), 2));
        chanceMean(b)= mean(nullMean_b, 'omitnan');
        chanceP95(b) = prctile(nullMean_b, 95);
    end

    %% Permutation comparisons

    dA1 = mean(real5(1,:) - real5(2,:));
    dA2 = mean(real5(3,:) - real5(4,:));
    dC1 = mean(real5(1,:) - real5(5,:));
    dC2 = mean(real5(2,:) - real5(5,:));
    dC3 = mean(real5(3,:) - real5(5,:));
    dC4 = mean(real5(4,:) - real5(5,:));

    nullA1 = squeeze(mean(ttPerm(:,:,1) - ttPerm(:,:,2), 2));
    nullA2 = squeeze(mean(ttPerm(:,:,3) - ttPerm(:,:,4), 2));

    nullC1 = squeeze(mean(ttPerm(:,:,1) - ttPerm(:,:,5), 2));
    nullC2 = squeeze(mean(ttPerm(:,:,2) - ttPerm(:,:,5), 2));
    nullC3 = squeeze(mean(ttPerm(:,:,3) - ttPerm(:,:,5), 2));
    nullC4 = squeeze(mean(ttPerm(:,:,4) - ttPerm(:,:,5), 2));

    pA1 = (sum( dirSign(1)*nullA1 >= dirSign(1)*dA1 ) + 1) / (Nperm + 1);
    pA2 = (sum( dirSign(2)*nullA2 >= dirSign(2)*dA2 ) + 1) / (Nperm + 1);

    pC1 = (sum( abs(nullC1) >= abs(dC1) ) + 1) / (Nperm + 1);
    pC2 = (sum( abs(nullC2) >= abs(dC2) ) + 1) / (Nperm + 1);
    pC3 = (sum( abs(nullC3) >= abs(dC3) ) + 1) / (Nperm + 1);
    pC4 = (sum( abs(nullC4) >= abs(dC4) ) + 1) / (Nperm + 1);

    %% Paired t-tests

    [~,p_tA1,~,stA1] = ttest(real5(1,:), real5(2,:));

    [~,p_tA2,~,stA2] = ttest(real5(3,:), real5(4,:));

    [~,p_tC1,~,stC1] = ttest(real5(1,:), real5(5,:));
    [~,p_tC2,~,stC2] = ttest(real5(2,:), real5(5,:));
    [~,p_tC3,~,stC3] = ttest(real5(3,:), real5(5,:));
    [~,p_tC4,~,stC4] = ttest(real5(4,:), real5(5,:));

    %% Decoding summaries

    axHandles(rr) = subplot(1, numel(ROIs), rr);
    hold(axHandles(rr), 'on');

    mu = mean(real5, 2, 'omitnan');
    eb = std(real5, 0, 2, 'omitnan') / sqrt(Nsub);

    cols = {cTask1, cTask2, cTask1, cTask2, cPV};

    barH = gobjects(1,3);

    for b = 1:5
        br = bar(xt(b), mu(b), 'EdgeColor','none', 'BarWidth',barWidth);
        br.FaceColor = cols{b};
        br.FaceAlpha = barAlpha;

        if b == 1
            br.DisplayName = 'Task 1'; barH(1) = br;
        elseif b == 2
            br.DisplayName = 'Task 2'; barH(2) = br;
        elseif b == 5
            br.DisplayName = 'PV';    barH(3) = br;
        else
            br.HandleVisibility = 'off';
        end

        errorbar(xt(b), mu(b), eb(b), '.', ...
            'LineWidth',1.5, 'Color',[0.5 0.5 0.5], 'CapSize',6, ...
            'HandleVisibility','off');

        scatter(xt(b) + linspace(-0.3,0.3,Nsub)*barWidth, ...
            real5(b,:), 20, 'o', 'MarkerEdgeColor',br.FaceColor, ...
            'MarkerFaceColor','w', 'LineWidth',1, 'HandleVisibility','off');
    end

    %% Decoding plots

    p_vsChance = nan(1,5);
    mu_obs     = mean(real5, 2, 'omitnan');

    for b = 1:5
        nullMean_b = squeeze(mean(ttPerm(:,:,b), 2));
        p_vsChance(b) = (sum(nullMean_b >= mu_obs(b)) + 1) / (Nperm + 1);
    end

    set(gca,'XTick',[(xt(1)+xt(2))/2, (xt(3)+xt(4))/2, xt(5)], ...
        'XTickLabel',{'Axis 1','Axis 2','Control'}, ...
        'FontName','Ariel','FontSize',12,'FontWeight','bold');

    ylabel('Correlation');
    set(gca,'FontName','Tahoma','FontSize',12,'FontWeight','bold');
    box off
    axis([1 9 -0.2 1.08])
    set(gca,'YTick',[-0.2 0 0.2 0.4 0.6 0.8 1]);
    title(roiTitles{rr},'Interpreter','none','FontName','Tahoma','FontSize',12,'FontWeight','bold');

    hNullMean = gobjects(1);
    hNullP95 = gobjects(1);
    for b = 1:5
        showInLegend = rr == numel(ROIs) && b == 1;
        [hMeanTmp, hP95Tmp] = drawNullLines(xt(b), chanceMean(b), ...
            chanceP95(b), barWidth, chanceGrey, showInLegend);
        if showInLegend
            hNullMean = hMeanTmp;
            hNullP95 = hP95Tmp;
        end
    end

    if rr == numel(ROIs)
        lgd = legend([barH hNullP95 hNullMean], ...
            {'Task 1','Task 2','PV','Chance (95th percentile)','Chance (mean)'}, ...
            'Location','none','FontName','Tahoma', ...
            'FontSize',10,'FontWeight','bold');
        legend boxoff
    end

    dy = 0.03;
    yTop = max(real5,[],'all','omitnan') + 0.05;

    addSigFlat(xt(1), xt(2), yTop + dy*0, pA1);
    addSigFlat(xt(3), xt(4), yTop + dy*0, pA2);

    fprintf('\n=== %s (Nperm=%d) ===\n', roiTitles{rr}, Nperm);

    fprintf('Axis1 Task1 vs Task2:\n');
    fprintf('  Perm(one-sided, +1): p = %.6f\n', pA1);
    fprintf('  t(%d)=%.3f, p=%.4g\n', stA1.df, stA1.tstat, p_tA1);

    fprintf('Axis2 Task1 vs Task2:\n');
    fprintf('  Perm(one-sided, +1): p = %.6f\n', pA2);
    fprintf('  t(%d)=%.3f, p=%.4g\n', stA2.df, stA2.tstat, p_tA2);

    fprintf('Task bars vs Control (two-sided):\n');
    fprintf('  Axis1 Task1 vs Ctrl: Perm p=%.6f | t(%d)=%.3f, p=%.4g\n', pC1, stC1.df, stC1.tstat, p_tC1);
    fprintf('  Axis1 Task2 vs Ctrl: Perm p=%.6f | t(%d)=%.3f, p=%.4g\n', pC2, stC2.df, stC2.tstat, p_tC2);
    fprintf('  Axis2 Task1 vs Ctrl: Perm p=%.6f | t(%d)=%.3f, p=%.4g\n', pC3, stC3.df, stC3.tstat, p_tC3);
    fprintf('  Axis2 Task2 vs Ctrl: Perm p=%.6f | t(%d)=%.3f, p=%.4g\n', pC4, stC4.df, stC4.tstat, p_tC4);

    fprintf('Bar vs Chance (one-sided perm; group-mean > null):\n');
    fprintf('  Axis1 Task1: p=%.6g | Axis1 Task2: p=%.6g | Axis2 Task1: p=%.6g | Axis2 Task2: p=%.6g | Control: p=%.6g\n', ...
        p_vsChance(1), p_vsChance(2), p_vsChance(3), p_vsChance(4), p_vsChance(5));

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
