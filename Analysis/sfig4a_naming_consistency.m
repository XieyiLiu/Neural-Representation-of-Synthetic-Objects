% Supplementary Fig. 4a: naming-consistency examples and distributions.
% Show high/low naming-consistency examples and correlation distributions.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig4a_naming_consistency.mat'));

%% Example images
[~,id]=sort(meanvec_mpnet_fake,'descend');
top10_high=id(1:10); top10_low=id(end:-1:end-9);
figure;
subplot(2,1,1);montage(uint8(reshape(img100_fake(:,:,top10_high),size(img100_fake,1),size(img100_fake,2),1,[])),'Size',[2 5]);title('High naming consistency');
subplot(2,1,2);montage(uint8(reshape(img100_fake(:,:,top10_low),size(img100_fake,1),size(img100_fake,2),1,[])),'Size',[2 5]);title('Low naming consistency');

%% Naming-consistency distributions
figure;
set(gcf,'Position',[500,300,564.2,450]); hold on;

v_real   = meanvec_mpnet_real(:);
v_fake   = rr_words_mpnet_lack(:);
v_random = RDM_straighten(corr_randomeng_mpnet);
v_fake_rich = rr_words_mpnet_rich(:);

nbins = 70;
edges = linspace(-1, 1, nbins+1);
binCenters = (edges(1:end-1) + edges(2:end)) / 2;

c_real   = [0.90 0.55 0.25];
c_fake   = [0.10 0.20 0.40];
c_random = [0.50 0.50 0.50];
c_fake_rich  = [0.40 0.80 0.67];

h1 = histogram(v_real,   edges, 'Normalization','probability', ...
    'FaceColor',c_real,   'FaceAlpha',0.22, 'EdgeColor','none');

h2 = histogram(v_fake,   edges, 'Normalization','probability', ...
    'FaceColor',c_fake,   'FaceAlpha',0.22, 'EdgeColor','none');

h3 = histogram(v_random, edges, 'Normalization','probability', ...
    'FaceColor',c_random, 'FaceAlpha',0.22, 'EdgeColor','none');

h4 = histogram(v_fake_rich,   edges, 'Normalization','probability', ...
    'FaceColor',c_fake_rich,   'FaceAlpha',0.22, 'EdgeColor','none');

p_real   = h1.Values;
p_fake   = h2.Values;
p_random = h3.Values;
p_fake_rich = h4.Values;

smooth_win = 8;
p_real_s   = smoothdata(p_real,   'gaussian', smooth_win);
p_fake_s   = smoothdata(p_fake,   'gaussian', smooth_win);
p_random_s = smoothdata(p_random, 'gaussian', smooth_win);
p_fake_rich   = smoothdata(p_fake_rich,   'gaussian', smooth_win);

plot(binCenters, p_real_s,   'Color',c_real,   'LineWidth',2.5);
plot(binCenters, p_fake_s,   'Color',c_fake,   'LineWidth',2.5);
plot(binCenters, p_random_s, 'Color',c_random, 'LineWidth',2.5);
plot(binCenters, p_fake_rich, 'Color',c_fake_rich, 'LineWidth',2.5);

m_real   = median(v_real);
m_fake   = median(v_fake);
m_random = median(v_random);
m_fake_rich = median(v_fake_rich);

ylim_now = ylim;

plot([m_real m_real],     ylim_now, '--', 'Color',c_real,   'LineWidth',1);
plot([m_fake m_fake],     ylim_now, '--', 'Color',c_fake,   'LineWidth',1);
plot([m_random m_random], ylim_now, '--', 'Color',c_random, 'LineWidth',1);
plot([m_fake_rich m_fake_rich], ylim_now, '--', 'Color',c_fake_rich, 'LineWidth',1);

xlabel('Pairwise correlation');
ylabel('Probability');
xlim([-0.1 1]);
box off;
set(gca,'FontSize',11);

legend([h1 h3 h2 h4],{'Real objects','Random nouns','Low (50 synthetic objects)','High (50 synthetic objects)'}, ...
       'Location','northeastoutside');

legend box off;
