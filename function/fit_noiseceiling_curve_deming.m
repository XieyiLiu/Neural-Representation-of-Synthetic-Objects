% Shared figure helper: Plot noise-ceiling densities with a Deming fit and Pearson correlation.
function stats = fit_noiseceiling_curve_deming(x, y, figTitle)

x2 = x(:);
y2 = y(:);

%% Valid inputs

assert(numel(x2)==numel(y2), ...
    'Noise ceiling 与模型拟合必须对应同一批神经元');

ok = isfinite(x2) & isfinite(y2);
x2 = x2(ok);
y2 = y2(ok);

%% Deming fit

lambda = 1;
if numel(x2) < 2 || all(x2==0)
    a = NaN;
    yhat = NaN(size(x2));
else
    a = deming_through_origin(x2, y2, lambda);
    yhat = a * x2;
end

if numel(x2) >= 3 && std(x2)>eps && std(y2)>eps
    [r,pearson_p] = corr(double(x2), double(y2), ...
        'Type','Pearson','Rows','complete','Tail','both');
else
    r = NaN;
    pearson_p = NaN;
end

ratio_med = median(y2 ./ x2, 'omitnan');

%% Density plot

lims = [-0.5 1.5];
nbin = 50;

xedges = linspace(lims(1), lims(2), nbin+1);
yedges = linspace(lims(1), lims(2), nbin+1);

N = histcounts2(x2, y2, xedges, yedges);

Z = log10(N');
Z(N'==0) = NaN;

figure;
imagesc(lims, lims, Z);
axis xy
axis equal
axis square
xlim(lims)
ylim(lims)

validZ = Z(~isnan(Z));
if ~isempty(validZ)
    caxis([prctile(validZ,5) prctile(validZ,98)]);
end

ncol = 256;
cmap = zeros(ncol,3);

rcol = linspace(1,0.85,ncol)';
idx = round(0.7*ncol):ncol;
rcol(idx) = linspace(0.85,0.60,numel(idx))';

gcol = linspace(1,0,ncol)';
bcol = linspace(1,0,ncol)';

cmap(:,1) = rcol;
cmap(:,2) = gcol;
cmap(:,3) = bcol;

colormap(cmap);

cb = colorbar;
cb.Label.String = 'log_{10} point density';
cb.Label.FontSize = 10;

hold on

%% Reference lines

xx = linspace(lims(1), lims(2), 300);

plot(xx, xx, '--', 'Color',[0.6 0.6 0.6], 'LineWidth',1.5);

if isfinite(a)
    plot(xx, a*xx, 'k-', 'LineWidth',2);
end

xlabel('Split-half reliability');
ylabel('Object space model performance (r)');
title(figTitle);
box off

txt = {
    sprintf('Slope = %.2f', a)
    sprintf('r = %.2f', r)
    sprintf('N = %d', numel(x2))
    };

text(0.02, 0.98, txt, ...
    'Units','normalized', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','top', ...
    'BackgroundColor','w', ...
    'Margin',6);

stats.a           = a;
stats.correlation = r;
stats.pearson_r   = r;
stats.pearson_p   = pearson_p;
stats.pearson_tail = 'two-sided';
stats.ratio_med   = ratio_med;
stats.N           = numel(x2);
stats.lambda      = lambda;
end
