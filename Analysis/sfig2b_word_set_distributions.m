% Supplementary Fig. 2b
% Compare pairwise word-embedding correlation distributions and their centers.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig2b_word_set_distributions.mat'));

figure;
set(gcf,'Position',[500,300,564.2,450]); hold on;

n = size(corr_rich1000_mpnet,1);
ut = find(triu(ones(n),1));

v_rich = corr_rich1000_mpnet(ut);
v_obj  = corr_obj1000_mpnet(ut);
v_noun = corr_noun1000_mpnet(ut);

%% Distribution centers

word_set_stats = table( ...
    {'Random English words'; 'Object-related words'; 'Nouns'}, ...
    [size(corr_rich1000_mpnet,1); size(corr_obj1000_mpnet,1); size(corr_noun1000_mpnet,1)], ...
    [numel(v_rich); numel(v_obj); numel(v_noun)], ...
    double([median(v_rich); median(v_obj); median(v_noun)]), ...
    [mean(double(v_rich)); mean(double(v_obj)); mean(double(v_noun))], ...
    'VariableNames', {'WordSet','NWords','NPairs','MedianR','MeanR'});
fprintf('\n=== Supplementary Fig. 2b: word-set distribution centers ===\n');
for word_set_idx = 1:height(word_set_stats)
    fprintf('%s: n = %d words, %d unique pairs; median r = %.8f, mean r = %.8f\n', ...
        word_set_stats.WordSet{word_set_idx}, word_set_stats.NWords(word_set_idx), ...
        word_set_stats.NPairs(word_set_idx), word_set_stats.MedianR(word_set_idx), ...
        word_set_stats.MeanR(word_set_idx));
end
fprintf('Across word sets, medians range from %.5f to %.5f.\n', ...
    min(word_set_stats.MedianR), max(word_set_stats.MedianR));

nbins = 70;
edges = linspace(-1, 1, nbins+1);
binCenters = (edges(1:end-1) + edges(2:end)) / 2;

c_rich = [0.40 0.40 0.40];
c_obj  = [0.65 0.18 0.15];
c_noun = [0.18 0.36 0.56];

%% Correlation distributions
h1 = histogram(v_rich, edges, 'Normalization','probability', ...
    'FaceColor',c_rich, 'FaceAlpha',0.22, 'EdgeColor','none');

h2 = histogram(v_obj, edges, 'Normalization','probability', ...
    'FaceColor',c_obj,  'FaceAlpha',0.22, 'EdgeColor','none');

h3 = histogram(v_noun, edges, 'Normalization','probability', ...
    'FaceColor',c_noun, 'FaceAlpha',0.22, 'EdgeColor','none');

p_rich = h1.Values;
p_obj  = h2.Values;
p_noun = h3.Values;

smooth_win = 11;
p_rich_s = smoothdata(p_rich, 'gaussian', smooth_win);
p_obj_s  = smoothdata(p_obj,  'gaussian', smooth_win);
p_noun_s = smoothdata(p_noun, 'gaussian', smooth_win);

plot(binCenters, p_rich_s, 'Color',c_rich, 'LineWidth',2.5);
plot(binCenters, p_obj_s,  'Color',c_obj,  'LineWidth',2.5);
plot(binCenters, p_noun_s, 'Color',c_noun, 'LineWidth',2.5);

xlabel('Pairwise correlation');
ylabel('Probability');
xlim([-0.1 1]);
box off;
set(gca,'FontSize',11);

legend({'Random words 1,000', ...
        'Object words 1,000', ...
        'Nouns 1,000'}, ...
       'Location','northeastoutside');
legend box off;
