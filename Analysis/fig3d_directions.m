% Fig. 3d / Supplementary Fig. 8c: real and synthetic directions
% Circular direction distributions and paired-unit circular-correlation permutations.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig3d_directions.mat'));

[data_real,data_fake,data_real_r,data_fake_r] = deal(cell(1,3));
for nn = 1:size(pol_real_all,1)
    nonEmptyColumns = find(~cellfun(@isempty,pol_real_all(nn,:)) == 1);
    ppall_real = cell2mat(pol_real_all(nn,nonEmptyColumns(1):nonEmptyColumns(end)));
    idreal = find(ppall_real(2,:)>3);

    nonEmptyColumns = find(~cellfun(@isempty,pol_fake_all(nn,:)) == 1);
    ppall_fake = cell2mat(pol_fake_all(nn,nonEmptyColumns(1):nonEmptyColumns(end)));
    idfake = find(ppall_fake(2,:)>3);

    idall = intersect(idreal,idfake);
    length(idall)

    data_real{nn} = ppall_real(1,idall);
    data_real_r{nn} = ppall_real(2,idall);

    data_fake{nn} = ppall_fake(1,idall);
    data_fake_r{nn} = ppall_fake(2,idall);
end
figure;
set(gcf,'Position',[744,591.4,700.2,458.6])

nbins = 22;
cc = [
    0.20 0.55 0.40;
    0.25 0.45 0.75;
    0.62 0.28 0.68
    ];

lgd_handle = gobjects(1,3);

for nn = 1:size(pol_real_all,1)

    data = data_real{nn};
    length(data)

    %% Real directions
    hh = histogram(data, nbins, ...
        'BinLimits', [-pi pi], ...
        'FaceColor', cc(nn,:), ...
        'FaceAlpha', 0.22, ...
        'EdgeAlpha', 0);
    hold on
    lgd_handle(nn) = hh;
    binEdges   = hh.BinEdges;
    binCenters = binEdges(1:end-1) + diff(binEdges)/2;
    binCounts  = hh.BinCounts;

    k = 2;
    counts_ext = [binCounts(end-k+1:end), binCounts, binCounts(1:k)];
    counts_smooth_ext = smoothdata(counts_ext, 'movmean', 3);
    counts_smooth = counts_smooth_ext(k+1:k+nbins);

    xi = linspace(-pi, pi, 200);
f = interp1( ...
    [binCenters-2*pi, binCenters, binCenters+2*pi], ...
    repmat(counts_smooth,1,3), xi, 'pchip');

    fill([xi fliplr(xi)], [f zeros(size(f))], ...
        cc(nn,:), ...
        'FaceAlpha', 0.28, ...
        'EdgeColor', 'none');

    plot(xi, f, ...
        'Color', cc(nn,:), ...
        'LineWidth', 2.6);

    med = circ_median(data(:));
    plot([med med], [0 max(f)*1.05], ...
        '--', 'Color', cc(nn,:), ...
        'LineWidth', 1.8, ...
        'HandleVisibility','off');
    ylim([0 350]);

    ylabel('Number of units')
    xlabel('\theta (rad)')
    xlim([-pi pi])
end

set(gca,'FontName','Arial','FontSize',10,'FontWeight','bold')

regionLabels = cellfun(@(region,angles) sprintf('%s (n = %d)',region,numel(angles)), ...
    {'Body','Face','Spiky'},reshape(data_real,1,[]),'UniformOutput',false);
lgd = legend(lgd_handle,regionLabels,'Location','eastoutside');
lgd.Box = 'off';

for i = 1:length(lgd_handle)
    lgd_handle(i).LineWidth = 2.6;
end
title('Real objects')
box off

figure;
set(gcf,'Position',[744,591.4,700.2,458.6])

nbins = 22;
cc = [
    0.20 0.55 0.40;
    0.25 0.45 0.75;
    0.62 0.28 0.68
    ];

lgd_handle = gobjects(1,3);

for nn = 1:size(pol_fake_all,1)

    data = data_fake{nn};
    length(data)

    %% Synthetic directions
    hh = histogram(data, nbins, ...
        'BinLimits', [-pi pi], ...
        'FaceColor', cc(nn,:), ...
        'FaceAlpha', 0.22, ...
        'EdgeAlpha', 0);
    hold on
    lgd_handle(nn) = hh;
    binEdges   = hh.BinEdges;
    binCenters = binEdges(1:end-1) + diff(binEdges)/2;
    binCounts  = hh.BinCounts;

    k = 2;
    counts_ext = [binCounts(end-k+1:end), binCounts, binCounts(1:k)];
    counts_smooth_ext = smoothdata(counts_ext, 'movmean', 3);
    counts_smooth = counts_smooth_ext(k+1:k+nbins);

    xi = linspace(-pi, pi, 200);
f = interp1( ...
    [binCenters-2*pi, binCenters, binCenters+2*pi], ...
    repmat(counts_smooth,1,3), xi, 'pchip');

    fill([xi fliplr(xi)], [f zeros(size(f))], ...
        cc(nn,:), ...
        'FaceAlpha', 0.28, ...
        'EdgeColor', 'none');

    plot(xi, f, ...
        'Color', cc(nn,:), ...
        'LineWidth', 2.6);

    med = circ_median(data(:));
    plot([med med], [0 max(f)*1.05], ...
        '--', 'Color', cc(nn,:), ...
        'LineWidth', 1.8, ...
        'HandleVisibility','off');

    ylabel('Number of units')
    xlabel('\theta (rad)')
    xlim([-pi pi])
end

set(gca,'FontName','Arial','FontSize',10,'FontWeight','bold')

regionLabels = cellfun(@(region,angles) sprintf('%s (n = %d)',region,numel(angles)), ...
    {'Body','Face','Spiky'},reshape(data_real,1,[]),'UniformOutput',false);
lgd = legend(lgd_handle,regionLabels,'Location','eastoutside');
lgd.Box = 'off';

for i = 1:length(lgd_handle)
    lgd_handle(i).LineWidth = 2.6;
end
title('Synthetic objects')
box off
ylim([0 350]);

%% Circular-correlation permutations

x_real = cell2mat(data_real);
x_fake = cell2mat(data_fake);

[r_obs, ~] = circ_corrcc(x_real, x_fake);

rng(0,'twister');
Nperm = 1000;
r_null = zeros(Nperm,1);

for p = 1:Nperm

    perm = randperm(size(x_real,2));
    r_null(p) = circ_corrcc(x_real, x_fake(perm));
end

p_perm = (sum(abs(r_null) >= abs(r_obs)) + 1) / (Nperm + 1);

fprintf('Observed circ-corr = %.3f\n', r_obs);
fprintf('Permutation p = %.4g\n', p_perm);

stats_theta = struct('region_names',{{'Body','Face','Spiky'}}, ...
    'n_by_region',cellfun(@numel,data_real), ...
    'n_units',numel(x_real),'r_obs',r_obs,'p_perm',p_perm, ...
    'Nperm',Nperm,'rng_seed',0,'tail','two-sided', ...
    'n_exceedances',sum(abs(r_null)>=abs(r_obs)),'r_null',r_null);
fprintf('Pooled Body/Face/Spiky: n = %d (%d/%d/%d), Nperm = %d, two-sided, seed = %d\n', ...
    stats_theta.n_units,stats_theta.n_by_region(1),stats_theta.n_by_region(2), ...
    stats_theta.n_by_region(3),stats_theta.Nperm,stats_theta.rng_seed);
