% Supplementary Fig. 13b: R scatter and theta statistics
% Circular map correlations and vertex-wise Pearson correlations/Deming slopes.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig13b_map_correlations.mat'));

%% Circular correlations
fprintf('\n===================== Circular correlation: SCT vs. PV =====================\n');
for nn = 1:nSubj
    theta_fake = theta_fake_all{nn};
    theta_pv   = theta_pv_all{nn};

    if numel(theta_fake) >= 3
        [rho, pval] = circ_corrcc(theta_fake,theta_pv);
    else
        rho = NaN; pval = NaN; ts = NaN;
    end

    fprintf('%s: rho = %.4f, %s, n = %d\n', ...
        name{nn}, rho, display_p_value(pval), numel(theta_fake));
end

%% Selectivity correlations
figure;
set(gcf,'Position',[100,120,1000,460])
set(gcf, 'Renderer', 'painters');

lambda = 1;
nbins  = [80,80];

all_xy = [];
for nn = 1:nSubj
    all_xy = [all_xy; r_fake_all{nn}; r_pv_all{nn}];
end

if isempty(all_xy)
    xy_low  = -1;
    xy_high =  1;
else
    prc = prctile(all_xy, [1 99]);

    xy_low_raw  = prc(1);
    xy_high_raw = prc(2);

    pad = 0.05 * (xy_high_raw - xy_low_raw + eps);

    xy_low  = xy_low_raw  - pad;
    xy_high = xy_high_raw + pad;

    xy_low  = floor(xy_low  * 2) / 2;
    xy_high = ceil( xy_high * 2) / 2;

    xy_low  = min(xy_low, 0);
    xy_high = max(xy_high, 0);

    if abs(xy_high - xy_low) < eps
        xy_low  = xy_low  - 1;
        xy_high = xy_high + 1;
    end
end

range_xy = xy_high - xy_low;
if range_xy <= 4
    tick_step = 0.5;
elseif range_xy <= 8
    tick_step = 1;
else
    tick_step = 2;
end

colordeep = slanCM('Purples');
colordeep(1,:) = [1,1,1];

for nn = 1:nSubj
    subplot(1,2,nn)

    x = r_fake_all{nn};
    y = r_pv_all{nn};

    [N, edgesX, edgesY] = histcounts2(x, y, nbins, ...
        'XBinLimits', [xy_low xy_high], ...
        'YBinLimits', [xy_low xy_high]);

    centerX = edgesX(1:end-1) + diff(edgesX)/2;
    centerY = edgesY(1:end-1) + diff(edgesY)/2;

    imagesc(centerX, centerY, N');
    hold on
    axis xy
    axis square

    plot([xy_low xy_high], [xy_low xy_high], ...
        'k--', 'LineWidth', 2, 'HandleVisibility','off');

    if ~isempty(x)
        x_med = median(x, 'omitnan');
        y_med = median(y, 'omitnan');

        plot(x_med, y_med, ...
            'Marker','+', ...
            'Color','y', ...
            'MarkerSize',10, ...
            'LineWidth',1.5);
    else
        x_med = NaN;
        y_med = NaN;
    end

    if numel(x) < 2 || std(x) < eps || std(y) < eps
        slope = NaN;
    else
        slope = deming_through_origin(x, y, lambda);
    end

    xline_now = [xy_low xy_high];
    if isfinite(slope)
        plot(xline_now, slope * xline_now, 'r-', 'LineWidth', 2);
    end

    if numel(x) >= 3 && std(x)>eps && std(y)>eps
        [r, p] = corr(x, y, 'Rows','complete', 'Type','Pearson');
    else
        r = NaN; p = NaN;
    end

    xlim([xy_low xy_high]);
    ylim([xy_low xy_high]);

    x_text = xy_high - 0.05 * (xy_high - xy_low);
    y_text = xy_low  + 0.10 * (xy_high - xy_low);

    text(x_text, y_text, ...
        {['slope = ' num2str(slope,'%.3f')], ...
        ['r = ' num2str(r,'%.3f')], ...
        display_p_value(p), ...
        ['n = ' num2str(numel(x))]}, ...
        'HorizontalAlignment','right', 'VerticalAlignment','bottom', ...
        'FontSize',10,'BackgroundColor','white','Margin',1, ...
        'FontName','Arial');

    title(name{nn}, 'FontName','Arial', 'FontSize',12);
    xlabel('Z-scored R (SCT)');
    ylabel('Z-scored R (PV)');

    xticks(xy_low:tick_step:xy_high);
    yticks(xy_low:tick_step:xy_high);

    colormap(gca, colordeep);
    caxis([0 15])
    cb = colorbar;
    cb.Label.String = 'Number of vertices';

    box off
    set(gca, ...
        'FontName','Arial', ...
        'FontSize',11, ...
        'TickDir','in', ...
        'LineWidth',1);
end

function label = display_p_value(p)
if ~isfinite(p)
    label = 'p unavailable';
elseif p < 0.001
    label = 'p < 0.001';
else
    label = sprintf('p = %.3g',p);
end
end

function slope = deming_through_origin(x, y, lambda)

x = x(:);
y = y(:);

good = isfinite(x) & isfinite(y);
x = x(good);
y = y(good);

if numel(x) < 2 || all(abs(x) < eps)
    slope = NaN;
    return
end

Sxx = mean(x.^2);
Syy = mean(y.^2);
Sxy = mean(x .* y);

if abs(Sxy) < eps
    slope = NaN;
    return
end

slope = (Syy - lambda*Sxx + sqrt((Syy - lambda*Sxx).^2 + 4*lambda*Sxy.^2)) ...
    / (2*Sxy);
end
