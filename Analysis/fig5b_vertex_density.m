% Fig. 5b: example participant density
% Vertex-wise selectivity densities, Deming slopes, and Pearson correlations.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig5b_vertex_density.mat'));
correlation_statistics = struct('comparison',{},'n',{},'pearson_r',{}, ...
    'pearson_p',{},'pearson_tail',{},'slope',{});

        figure;
        set(gcf,'Position',[100,60,480,900])
        set(gcf, 'Renderer', 'painters');

        lambda = 1;

        subplot(3,1,1)
        nbins = [80, 80];
        [N, edgesX, edgesY] = histcounts2(p1_rl(:,2), p2_rl(:,2), nbins);
        colordeep = slanCM('Purples');
        colordeep(1,:) = [1,1,1];
        imagesc(edgesX, edgesY, N');hold on
        plot(0:0.01:11,0:0.01:11,'LineStyle','--','Color','k','LineWidth',2,'HandleVisibility','off');hold on
        plot(mmall(ss,1),mmall(ss,2),'.y','MarkerSize',10,'Marker','+');

        x = p1_rl(:,2);
        y = p2_rl(:,2);
        good = isfinite(x) & isfinite(y);
        x = x(good);
        y = y(good);

        if numel(x) < 2 || all(x==0) || all(y==0)
            slope = NaN;
        else
            slope = deming_through_origin(x, y, lambda);
        end

        xline = [0 11];
        if isfinite(slope)
            plot(xline, slope*xline, 'r-', 'LineWidth', 2); hold on
        end

        if numel(x) >= 3 && std(x)>eps && std(y)>eps
            [r,pearson_p] = corr(double(x), double(y), ...
                'Type','Pearson','Rows','complete','Tail','both');
        else
            r = NaN;
            pearson_p = NaN;
        end
        correlation_statistics(1) = struct('comparison','Task 1 vs Task 2', ...
            'n',numel(x),'pearson_r',r,'pearson_p',pearson_p, ...
            'pearson_tail','two-sided','slope',slope);


        text(0.97, 0.06, ...
            {['slope = ' num2str(slope,'%.3f')], ...
            ['r = ' num2str(r,'%.3f')]}, ...
            'Units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom', ...
            'FontSize',11, 'FontName','Arial');

        axis([0,11,0,11])
        xticks([0:2:10]);
        xlabel('Z-scored R (Task 1)');
        ylabel('Z-scored R (Task 2)');
        axis xy;
        axis square
        colormap(colordeep);
        caxis([0 25])
        colorbar;
        box off

        subplot(3,1,2)
        nbins = [80, 80];
        [N, edgesX, edgesY] = histcounts2(p1_rl(:,2),ppv_rl(:,2), nbins);
        imagesc(edgesX, edgesY, N');hold on
        plot(0:0.01:11,0:0.01:11,'LineStyle','--','Color','k','LineWidth',2,'HandleVisibility','off');hold on
        plot(mmall(ss,1),mmall(ss,3),'.y','MarkerSize',10,'Marker','+');

        x = p1_rl(:,2);
        y = ppv_rl(:,2);
        good = isfinite(x) & isfinite(y);
        x = x(good);
        y = y(good);

        if numel(x) < 2 || all(x==0) || all(y==0)
            slope = NaN;
        else
            slope = deming_through_origin(x, y, lambda);
        end

        xline = [0 11];
        if isfinite(slope)
            plot(xline, slope*xline, 'r-', 'LineWidth', 2); hold on
        end

        if numel(x) >= 3 && std(x)>eps && std(y)>eps
            [r,pearson_p] = corr(double(x), double(y), ...
                'Type','Pearson','Rows','complete','Tail','both');
        else
            r = NaN;
            pearson_p = NaN;
        end
        correlation_statistics(2) = struct('comparison','Task 1 vs PV', ...
            'n',numel(x),'pearson_r',r,'pearson_p',pearson_p, ...
            'pearson_tail','two-sided','slope',slope);


        text(0.97, 0.06, ...
            {['slope = ' num2str(slope,'%.3f')], ...
            ['r = ' num2str(r,'%.3f')]}, ...
            'Units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom', ...
            'FontSize',11, 'FontName','Arial');

        axis([0,11,0,11])
        xticks([0:2:10]);
        xlabel('Z-scored R (Task 1)');
        ylabel('Z-scored R (PV)');
        axis xy;
        axis square
        colormap(colordeep);
        caxis([0 25])
        colorbar;
        box off

        subplot(3,1,3)
        nbins = [80, 80];
        [N, edgesX, edgesY] = histcounts2(p2_rl(:,2),ppv_rl(:,2), nbins);
        imagesc(edgesX, edgesY, N');hold on
        plot(0:0.01:11,0:0.01:11,'LineStyle','--','Color','k','LineWidth',2,'HandleVisibility','off');hold on
        plot(mmall(ss,2),mmall(ss,3),'.y','MarkerSize',10,'Marker','+');

        x = p2_rl(:,2);
        y = ppv_rl(:,2);
        good = isfinite(x) & isfinite(y);
        x = x(good);
        y = y(good);

        if numel(x) < 2 || all(x==0) || all(y==0)
            slope = NaN;
        else
            slope = deming_through_origin(x, y, lambda);
        end

        xline = [0 11];
        if isfinite(slope)
            plot(xline, slope*xline, 'r-', 'LineWidth', 2); hold on
        end

        if numel(x) >= 3 && std(x)>eps && std(y)>eps
            [r,pearson_p] = corr(double(x), double(y), ...
                'Type','Pearson','Rows','complete','Tail','both');
        else
            r = NaN;
            pearson_p = NaN;
        end
        correlation_statistics(3) = struct('comparison','Task 2 vs PV', ...
            'n',numel(x),'pearson_r',r,'pearson_p',pearson_p, ...
            'pearson_tail','two-sided','slope',slope);


        text(0.97, 0.06, ...
            {['slope = ' num2str(slope,'%.3f')], ...
            ['r = ' num2str(r,'%.3f')]}, ...
            'Units','normalized','HorizontalAlignment','right','VerticalAlignment','bottom', ...
            'FontSize',11, 'FontName','Arial');

        axis([0,11,0,11])
        xticks([0:2:10])
        xlabel('Z-scored R (Task 2)');
        ylabel('Z-scored R (PV)');
        axis xy;
        axis square
        colormap(colordeep);
        caxis([0 25])
        colorbar;
        box off

fprintf('\n=== Fig. 5b: two-sided Pearson correlation tests ===\n');
for report_index = 1:numel(correlation_statistics)
    result = correlation_statistics(report_index);
    if result.pearson_p == 0
        p_text = 'p < 0.001 (MATLAB numerical underflow; not an exact zero)';
    else
        p_text = sprintf('p = %.2e',result.pearson_p);
    end
    fprintf('%s: n = %d, r = %.8f, slope = %.8f, %s\n', ...
        result.comparison,result.n,result.pearson_r,result.slope,p_text);
end
