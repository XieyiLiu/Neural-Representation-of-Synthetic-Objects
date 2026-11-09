% Fig. 2f: real and synthetic selectivity.
% Deming slopes, Pearson/circular correlations, and one-sided permutations with add-one correction.
% ROI means use a two-sided Pearson test; pooled vertices use permutation tests.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig2f_surface_map_correlations_together.mat'));

dataall = cell(2,8);
datasmp = cell(8,2);
common_vertices = cell(1,2);
polall = cell(1,2); polall_fake = cell(1,2); polall_real = cell(1,2);
for hh = 1:2
    v_fake = cache.ind_fake{hh}(:);
    v_real = cache.ind_real{hh}(:);
    common_vertices{hh} = intersect(v_real,v_fake,'stable');
    [~,idx_fake] = ismember(common_vertices{hh},v_fake);
    [~,idx_real] = ismember(common_vertices{hh},v_real);

    polall{hh} = cache.polall{hh}(idx_fake,:,:);
    polall_fake{hh} = cache.polall_fake{hh}(idx_fake,:);
    polall_real{hh} = cache.polall_real{hh}(idx_real,:);
    datasmp{1,hh} = cache.polall_fake{hh}(idx_fake,2);
    datasmp{2,hh} = cache.polall_real{hh}(idx_real,2);
    datasmp{7,hh} = cache.polall_real{hh}(idx_real,1);
    datasmp{8,hh} = cache.polall_fake{hh}(idx_fake,1);
    nVertices = max([v_fake;v_real]);
    for sn = [1,2,7,8]
        dd = zeros(nVertices,1,'like',datasmp{sn,hh});
        dd(common_vertices{hh}) = datasmp{sn,hh};
        dataall{hh,sn} = dd;
    end
end
lh = common_vertices{1};
rh = common_vertices{2};

vcroi_lh = cellfun(@(x) intersect(x,lh),vc(1,:),'UniformOutput',false);
vcroi_rh = cellfun(@(x) intersect(x,rh),vc(2,:),'UniformOutput',false);

for ss = 1:2
    for rr = 1:length(roiall)
        datavcroi(rr,1,ss) = cellfun(@(x) x(vcroi_lh{rr}),dataall(1,ss),'UniformOutput',false);
        datavcroi(rr,2,ss) = cellfun(@(x) x(vcroi_rh{rr}),dataall(2,ss),'UniformOutput',false);
    end
end

for ss = 7:8
    for rr = 1:length(roiall)
        datavcroi_theta(rr,1,ss) = cellfun(@(x) x(vcroi_lh{rr}),dataall(1,ss),'UniformOutput',false);
        datavcroi_theta(rr,2,ss) = cellfun(@(x) x(vcroi_rh{rr}),dataall(2,ss),'UniformOutput',false);
    end
end

figure;
set(gcf,'Position',[130.6,233,927.2,652.8])

lambda = 1;

%% Vertex-wise selectivity

subplot(1,2,1)

X = cell2mat(datasmp(1,1:2)');
Y = cell2mat(datasmp(2,1:2)');

good = isfinite(X) & isfinite(Y);
Xg = X(good);
Yg = Y(good);

if numel(Xg) < 2 || all(Xg==0) || all(Yg==0)
    slope1 = NaN;
else
    slope1 = deming_through_origin(Xg, Yg, lambda);
end

R1 = corr(X, Y, 'rows','complete');

nbins = [80, 80];
[N, edgesX, edgesY] = histcounts2(X, Y, nbins);

colordeep(1,:) = [1,1,1];
imagesc(edgesX, edgesY, N'); hold on
plot(-2:13,-2:13,'LineStyle','--','Color','k','LineWidth',2,'HandleVisibility','off'); hold on

if isfinite(slope1)
    xfit = [-2 13];
    plot(xfit, slope1*xfit,'r-', 'LineWidth', 2)
end

xticks([0,4,8,12]); yticks([0,4,8,12])
xlabel('Z-scored R value (100 synthetic objects)');
ylabel('Z-scored R value (100 real objects)');
axis([-2 13 -2 13]); axis xy; axis square
colormap(colordeep); caxis([0 14]); colorbar;

ax = gca;
set(ax, 'FontName', 'Arial', 'FontSize', 8);

txt1 = sprintf('slope = %.3f\nr = %.3f', slope1, R1);
text(0.03, 0.97, txt1, 'Units','normalized', ...
    'HorizontalAlignment','left','VerticalAlignment','top', ...
    'FontName','Arial','FontSize',8,'FontWeight','bold','Margin',6);

%% ROI-mean selectivity

subplot(1,2,2)

xx = [];
yy = [];
for hh = 1:length(hmall)
    for rr = 1:length(roiall)
        if hh == 1
            scatter(mean(datavcroi{rr,hh,1}),mean(datavcroi{rr,hh,2}),70,'filled','MarkerFaceColor',cc{rr}); hold on
        elseif hh == 2
            scatter(mean(datavcroi{rr,hh,1}),mean(datavcroi{rr,hh,2}),60,'MarkeredgeColor',cc{rr},'LineWidth',2); hold on
        end
        xx = [xx, mean(datavcroi{rr,hh,1})];
        yy = [yy, mean(datavcroi{rr,hh,2})];
    end
    legend(roiall,'Box','off','Location','eastoutside','AutoUpdate','off');
    plot(2:15,2:15,'LineStyle','--','Color','k','LineWidth',2,'HandleVisibility','off')
    xlabel('Z-scored R value (100 synthetic objects)');
    ylabel('Z-scored R value (100 real objects)');
    set(gca,'FontName','Arial','FontSize',8)
    xticks(0:2:12); yticks(0:2:12)
    box off
    axis([2 12 2 12]); axis square
end

x_all = vertcat(datavcroi{:, :, 1});
y_all = vertcat(datavcroi{:, :, 2});

x_all = x_all(:);
y_all = y_all(:);

assert(numel(x_all) == numel(y_all), 'x and y lengths do not match');

[r, p] = corr(x_all, y_all, 'Rows','complete');
fprintf('Correlation: r = %.4f, p = %.4g\n', r, p);

X2 = xx(:);
Y2 = yy(:);

good2 = isfinite(X2) & isfinite(Y2);
X2g = X2(good2);
Y2g = Y2(good2);

if numel(X2g) < 2 || all(X2g==0) || all(Y2g==0)
    slope2 = NaN;
else
    slope2 = deming_through_origin(X2g, Y2g, lambda);
end

[R2, p_R2] = corr(xx(:), yy(:), 'rows','complete');

if isfinite(slope2)
    xfit = [2 12];
    plot(xfit, slope2*xfit, 'r-', 'LineWidth', 2);
end

ax = gca;
set(ax, 'FontName', 'Arial', 'FontSize', 8);

txt2 = sprintf('slope = %.3f\nr = %.3f', slope2, R2);
text(0.03, 0.97, txt2, 'Units','normalized', ...
    'HorizontalAlignment','left','VerticalAlignment','top', ...
    'FontName','Arial','FontSize',8,'FontWeight','bold','Margin',6);

Xtheta = cell2mat(datasmp(7,1:2)');
Ytheta = cell2mat(datasmp(8,1:2)');
idx = find(X>3 & Y>3);
[rho,pval] = circ_corrcc(Xtheta(idx),Ytheta(idx))
corrcoef([datasmp{1,1};datasmp{1,2}],[datasmp{2,1};datasmp{2,2}])

%% Pooled ROI vertices

polall_roi = cell(3,length(hmall));
for hh = 1:length(hmall)
    vcroiindex = cell2mat(vc(hh,1:length(roiall))');
    [tf, idx_in_common] = ismember(vcroiindex, common_vertices{hh});
    idx_in_common = idx_in_common(tf);
    polall_roi{1,hh} = polall{hh}(idx_in_common,:,:);
    polall_roi{2,hh} = polall_real{hh}(idx_in_common,:);
    polall_roi{3,hh} = polall_fake{hh}(idx_in_common,:);
end
Nperm = size(polall{1},3);
assert(size(polall{2},3)==Nperm, 'LH/RH permutation counts differ.');

%% Selectivity permutations
r_real = cell2mat(polall_real');
r_real = squeeze(r_real(:,2,:));
r_fake = cell2mat(polall');
r_fake = squeeze(r_fake(:,2,:));
corrnull_all = zeros(1,Nperm);
for i = 1:Nperm
    corrnull_all(i) = corr(r_fake(:,i),r_real);
end
r_real = cell2mat(polall_roi(2,:)');
r_real = squeeze(r_real(:,2,:));
r_fake = cell2mat(polall_roi(1,:)');
r_fake = squeeze(r_fake(:,2,:));
corrnull_roi = zeros(1,Nperm);
for i = 1:Nperm
    corrnull_roi(i) = corr(r_fake(:,i),r_real);
end

real_corr = cell2mat(polall_real');
fake_corr = cell2mat(polall_fake');
r_obs_all = corr(real_corr(:,2),fake_corr(:,2),'rows','complete');
real_roi = cell2mat(polall_roi(2,:)');
fake_roi = cell2mat(polall_roi(3,:)');
r_obs_roi = corr(real_roi(:,2),fake_roi(:,2),'rows','complete');

Nperm = numel(corrnull_all);

p_all = (sum(corrnull_all >= r_obs_all) + 1) / (Nperm + 1);

p_roi = (sum(corrnull_roi >= r_obs_roi) + 1) / (Nperm + 1);

stats_R = struct('r_all_vertices',r_obs_all, 'r_pooled_ROI_vertices',r_obs_roi, ...
    'p_all_vertices',p_all, 'p_pooled_ROI_vertices',p_roi, ...
    'null_all_vertices',corrnull_all, 'null_pooled_ROI_vertices',corrnull_roi);
fprintf('\nR permutation test: Nperm = %d, one-sided (null >= observed)\n',Nperm);
fprintf('  High-level visual area: r = %.6f, p = %.9g\n',stats_R.r_all_vertices,stats_R.p_all_vertices);
fprintf('  Pooled ROI vertices:    r = %.6f, p = %.9g\n',stats_R.r_pooled_ROI_vertices,stats_R.p_pooled_ROI_vertices);

%% Direction permutations
idx = find(real_corr(:,2)>3&fake_corr(:,2)>3);
idx_roi = find(real_roi(:,2)>3&fake_roi(:,2)>3);

r_real = cell2mat(polall_real');
r_real = squeeze(r_real(idx,1,:));
r_fake = cell2mat(polall');
r_fake = squeeze(r_fake(idx,1,:));
corrnull_all = zeros(1,Nperm);
for i = 1:Nperm
    [rho, pval] = circ_corrcc(r_fake(:,i),r_real);
    corrnull_all(i) = rho;
end
r_real = cell2mat(polall_roi(2,:)');
r_real = squeeze(r_real(idx_roi,1,:));
r_fake = cell2mat(polall_roi(1,:)');
r_fake = squeeze(r_fake(idx_roi,1,:));
corrnull_roi = zeros(1,Nperm);
for i = 1:Nperm
    [rho, pval] = circ_corrcc(r_fake(:,i),r_real);
    corrnull_roi(i) = rho;
end

[rho_roi, ~] = circ_corrcc(real_roi(idx_roi,1),fake_roi(idx_roi,1));
[rho_all, ~] = circ_corrcc(real_corr(idx,1),fake_corr(idx,1));

Nperm = numel(corrnull_all);

p_all = (sum(corrnull_all >= rho_all) + 1) / (Nperm + 1);

p_roi = (sum(corrnull_roi >= rho_roi) + 1) / (Nperm + 1);

stats_theta = struct('rho_all_vertices',rho_all, 'rho_pooled_ROI_vertices',rho_roi, ...
    'p_all_vertices',p_all, 'p_pooled_ROI_vertices',p_roi, ...
    'null_all_vertices',corrnull_all, 'null_pooled_ROI_vertices',corrnull_roi);
fprintf('\nTheta permutation test: Nperm = %d, one-sided (null >= observed)\n',Nperm);
fprintf('  High-level visual area: rho = %.6f, p = %.9g\n',stats_theta.rho_all_vertices,stats_theta.p_all_vertices);
fprintf('  Pooled ROI vertices:    rho = %.6f, p = %.9g\n',stats_theta.rho_pooled_ROI_vertices,stats_theta.p_pooled_ROI_vertices);

%% Manuscript statistics

stats_fig2f = struct;
stats_fig2f.left = struct('n_vertices',sum(good), 'r',R1, ...
    'p_permutation',stats_R.p_all_vertices, 'slope',slope1, 'Nperm',Nperm);
stats_fig2f.right = struct('n_ROI_means',sum(good2), 'r',R2, ...
    'p_pearson_two_sided',p_R2, 'slope',slope2);
fprintf('\nFig. 2f statistics for the manuscript\n');
fprintf('  Left (vertex-wise): r = %.2f, p = %.2e (one-sided permutation test), slope = %.2f; n = %d, Nperm = %d\n', ...
    stats_fig2f.left.r,stats_fig2f.left.p_permutation,stats_fig2f.left.slope, ...
    stats_fig2f.left.n_vertices,stats_fig2f.left.Nperm);
fprintf('  Right (ROI means):  r = %.2f, p = %.2e (Pearson, two-sided), slope = %.2f; n = %d\n', ...
    stats_fig2f.right.r,stats_fig2f.right.p_pearson_two_sided,stats_fig2f.right.slope, ...
    stats_fig2f.right.n_ROI_means);
