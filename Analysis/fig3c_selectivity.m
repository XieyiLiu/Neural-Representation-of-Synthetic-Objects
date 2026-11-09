% Fig. 3c: Body, Face and Spiky selectivity
% Compare real/synthetic selectivity using Deming slopes and Pearson correlations.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig3c_selectivity.mat'));

point_color=[29 31 135]/255;
region_statistics=struct([]);
for aaa=1:numel(cat)
    pol_mean_all=pol_mean_by_region{aaa};
    fprintf('\n%s patch\n',cat{aaa});
figure;

    xxx = [];
    yyy = [];
    for nn = 1:size(pol_mean_all,3)
        xxx = [xxx, pol_fake_all{aaa,nn}(2,:)];
        yyy = [yyy, pol_real_all{aaa,nn}(2,:)];
        scatter(pol_fake_all{aaa,nn}(2,:), pol_real_all{aaa,nn}(2,:), 6, ...
            'MarkerFaceColor', point_color, 'MarkeredgeColor', point_color); hold on
    end

    plot(-3:13, -3:13, '--', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);

    min(xxx)
    [h,paired_t_p,ci,stats] = ttest(xxx, yyy);
    % The figure's r asterisks refer to Pearson correlation significance.
    % Use double precision to retain very small Pearson p values.
    [pearson_r,pearson_p] = corr(double(xxx(:)), double(yyy(:)), ...
        'Type','Pearson','Tail','both');
    fprintf('Pearson correlation (two-sided; figure r significance): n = %d, r = %.8f, p = %.2e\n', ...
        numel(xxx),pearson_r,pearson_p);
    fprintf('Paired t-test (two-sided; synthetic - real): t(%d) = %.8f, p = %.2e\n', ...
        stats.df,stats.tstat,paired_t_p);

    x = xxx(:);
    y = yyy(:);

    lambda = 1;
    slope = deming_through_origin(x, y, lambda);

    fprintf('斜率为(Deming, origin): %.4f\n', slope);

    if isfinite(slope)
        xline = [-5 13];
        plot(xline, slope*xline, 'r-', 'LineWidth', 2); hold on
    end

    xlabel('Z-scored R (Synthetic)')
    ylabel('Z-scored R (Real)')
    set(gca,'FontName','Ariel','FontSize',10,'FontWeight','bold')
    axis([-5,13,-5,13])
    xticks([-4:4:12]);
    yticks([-4:4:12]);
    axis square
    title([cat{aaa} ' area'],'FontName','Ariel','FontSize',10,'FontWeight','bold')
    Rmat = corrcoef(xxx, yyy);
    r = Rmat(1,2);
    n = numel(xxx);

    text(0.68, 0.27, ...
        sprintf('n = %d\nr = %.2f\nslope = %.2f', n, r, slope), ...
        'Units','normalized', ...
        'FontName','Arial','FontSize',10, ...
        'FontWeight','normal','Color','k', ...
        'HorizontalAlignment','left', ...
        'VerticalAlignment','top', ...
        'Interpreter','none');
    region_statistics(aaa).region=cat{aaa};
    region_statistics(aaa).n=n;
    region_statistics(aaa).r=double(r);
    region_statistics(aaa).slope=slope;
    region_statistics(aaa).pearson_r=double(pearson_r);
    region_statistics(aaa).pearson_p=double(pearson_p);
    region_statistics(aaa).pearson_tail='two-sided';
    region_statistics(aaa).paired_t_p=double(paired_t_p);
    region_statistics(aaa).paired_t_t=double(stats.tstat);
    region_statistics(aaa).paired_t_df=double(stats.df);
    region_statistics(aaa).paired_t_direction='synthetic - real';
end
