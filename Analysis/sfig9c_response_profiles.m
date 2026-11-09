% Supplementary Fig. 9c: synthetic-object Q1-Q4 response profiles in three regions.
% Normalize and smooth synthetic-object quadrant PSTHs; plot population means and SEM.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig9c_response_profiles.mat'));

psth_results = cell(1,numel(regions));
for region_index = 1:numel(regions)
    psthresult = regions(region_index).psthresult;
    psth_range = regions(region_index).psth_range;
    session_sizes = regions(region_index).session_sizes;
    raw_unit_ids = regions(region_index).raw_unit_ids;

    legend_text={'Q1','Q2','Q3','Q4'};cc=[74,77,138;154,79,74;127,131,214;227,120,126]/255;ttl=[regions(region_index).region_name ' area (Synthetic)'];
    psthresult_norm = zeros(size(psthresult));

    for nn = 1:size(psthresult,3)
        dt = psthresult(:,:,nn);
        mx = max(abs(dt(:)));
        if mx > 0
            psthresult_norm(:,:,nn) = dt ./ mx;
        else
            psthresult_norm(:,:,nn) = dt;
        end
    end

    psth_smooth = movmean(psthresult_norm,20,2);

    pall = mean(psth_smooth,3)';
    pall_errbar = ...
        (std(psth_smooth,0,3)./sqrt(size(psth_smooth,3)))';

    h = figure('Name',ttl,'NumberTitle','off');
    whitebg(h,'white');
    set(h,'Position',[560,423,646,482])

    axs = axes();
    area(axs,[0 200],[2 2], ...
        'FaceColor',[0.9 0.9 0.9], ...
        'EdgeColor','none', ...
        'HandleVisibility','off');
    hold on

    area(axs,[0 200],[max(pall(:))+3 max(pall(:))+3], ...
        'FaceColor',[0.9 0.9 0.9], ...
        'EdgeColor','none', ...
        'HandleVisibility','off');
    hold on

    for i = 1:size(pall,2)
        H = shadedErrorBar( ...
            psth_range, ...
            pall(:,i), ...
            pall_errbar(:,i), ...
            'lineProps', {'-', 'Color', cc(i,:), 'LineWidth', 3}, ...
            'transparent', true, ...
            'patchSaturation', 0.2);
        set(H.edge, 'Visible', 'off');
        hold on
    end

    legend(legend_text)
    legend('boxoff')
    xlim([-50,400])
    ylim([min(pall(:))-0.03, max(pall(:))+0.03])
    ylabel('Avg. Norm. firing rate')
    xlabel('Time (ms)')

    ax = gca;
    set(ax, 'FontName', 'Arial');
    set(ax, 'FontSize', 15);
    box off
    title(ttl, 'FontName','Arial','FontSize',10,'FontWeight','bold')

    psth_results{region_index} = struct('region',regions(region_index).region_name, ...
        'mean',pall,'sem',pall_errbar,'n_units',size(psthresult,3));
end
