% Supplementary Fig. 7b: Body, Face and Spiky response heatmaps.
% Plot per-unit response heatmaps for Body, Face, and Spiky regions.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig7b_response_heatmaps.mat'));

for region_index=1:numel(regions)
    fr_plot=regions(region_index).fr_plot;
    nn_Session=regions(region_index).nn_Session;
    Datause=regions(region_index).Datause;

figure('Name',regions(region_index).region_name,'NumberTitle','off');
    set(gcf,'Position',[100,100,850,450]);
    imagesc(fr_plot(:,[1:50,52:72,51]));
    size(fr_plot,1)
    caxis([-1 2])
    colorbar
    tp = im2uint8(colormap(slanCM('bwr')));
    colormap(tp)
    ax = gca;
    xticks([12,36,54,66]);
    xticklabels({'Body','Face','Stubby','Spiky'})
    hold(ax, 'on');

    sessionEnd = cumsum(nn_Session);
    sessionCenter = sessionEnd - (nn_Session - 1)/2;

    yline(ax, sessionEnd(1:end-1) + 0.5, 'k--', ...
        'LineWidth', 1);

    xline(ax, [24.5, 48.5, 60.5], 'k-', ...
        'LineWidth', 1.2);

    yticks(ax, sessionCenter);
    yticklabels(ax, Datause);

    xlim(ax, [0.5, 72.5]);
    ylim(ax, [0.5, size(fr_plot,1) + 0.5]);

    plot(ax, 0.5*ones(size(sessionCenter)), sessionCenter, 'ko', ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 3, ...
        'LineStyle', 'none', ...
        'Clipping', 'off');
    set(ax, 'FontName', 'Arial');
    set(ax, 'FontSize', 15);
end
