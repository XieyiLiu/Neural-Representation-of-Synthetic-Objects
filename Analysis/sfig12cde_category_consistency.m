% Supplementary Fig. 12c-e: semantic-category consistency.
% Summarize within/across-subject agreement and dominant-category probabilities.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig12cde_category_consistency.mat'));

%% Within-subject consistency
fig2 = figure;
set(fig2, 'Position', [79,475,1413,460]);

withinColors = [
    0.996 0.878 0.902;
    0.988 0.733 0.800;
    0.918 0.573 0.718;
    0.737 0.396 0.671;
    0.510 0.247 0.604;
    0.247 0.000 0.490
];

plotConds = {'fake','real'};

withinLevels = [1/6 2/6 3/6 4/6 5/6 6/6];
withinLabels = {'1/6','2/6','3/6','4/6','5/6','6/6'};

for cc = 1:numel(plotConds)

    condName = plotConds{cc};

    subplot(1,2,cc);
    hold on;

    idxCond = strcmp(subImgSummary.condition, condName);

    if sum(idxCond) == 0
        warning('No data for the %s condition.',regexprep(condName,'^fake$','Synthetic','ignorecase'));
        title(['No data: ' regexprep(condName,'^fake$','Synthetic','ignorecase')]);
        continue;
    end

    countWithin = nan(numel(plot_sub_names), numel(withinLevels));

    for ss = 1:numel(plot_sub_names)

        subName = plot_sub_names{ss};

        idxThis = idxCond & strcmp(subImgSummary.subject, subName);

        cons = subImgSummary.withinSubConsistency_strict6(idxThis);

        for ll = 1:numel(withinLevels)
            countWithin(ss,ll) = sum(abs(cons - withinLevels(ll)) < 1e-6);
        end

    end

    b2 = bar(countWithin, 'stacked');

    for ll = 1:numel(b2)
        b2(ll).FaceColor = withinColors(ll,:);
        b2(ll).EdgeColor = 'none';
    end

    set(gca, 'XTick', 1:numel(plot_sub_names));
    set(gca, 'XTickLabel', plot_sub_labels);
    set(gca, 'FontName', 'Arial', 'FontSize', 12);

    ylabel('Number of images');

    if strcmp(condName, 'fake')
        title('Within-subject consistency (Synthetic)');
    elseif strcmp(condName, 'real')
        title('Within-subject consistency (Real)');
    else
        title([condName ': within-subject consistency']);
    end

    ylim([0 105]);
    box off;

    legend(withinLabels, ...
        'Location', 'eastoutside', ...
        'Box', 'off');

end

sgtitle('Within-subject semantic-category consistency across 6 scans', ...
    'FontName', 'Arial', ...
    'FontSize', 14, ...
    'FontWeight', 'bold');

%% Across-subject consistency
figure;

acrossColors = [
    0.671 0.851 0.914;
    0.129 0.443 0.710;
    0.031 0.188 0.420
];

realColor = [0.902 0.424 0.059];
fakeColor = [0.129 0.443 0.710];
barAlpha = 0.45;
hold on;

acrossLevels = [0.50 0.75 1.00];
acrossLabels = {'2/4','3/4','4/4'};

countAcross = nan(numel(cond_names), numel(acrossLevels));

for cc = 1:numel(cond_names)

    condName = cond_names{cc};
    idxCond = strcmp(imageConsistency.condition, condName);

    idxUse = idxCond & imageConsistency.nSubjectValid == 4;

    cons = imageConsistency.acrossSubCatConsistency(idxUse);

    for ll = 1:numel(acrossLevels)
        countAcross(cc,ll) = sum(abs(cons - acrossLevels(ll)) < 1e-6);
    end

end

b1 = bar(countAcross, 'grouped');

for ll = 1:numel(b1)
    b1(ll).FaceColor = acrossColors(ll,:);
    b1(ll).EdgeColor = 'none';
end

set(gca, 'XTick', 1:numel(cond_names));
display_conditions = regexprep(cond_names,'^fake$','Synthetic','ignorecase');
display_conditions = regexprep(display_conditions,'^real$','Real','ignorecase');
set(gca, 'XTickLabel', display_conditions);
set(gca, 'FontName', 'Arial', 'FontSize', 12);

ylabel('Number of images');
title('Across-subject consistency');

legend(acrossLabels, ...
    'Location', 'northwest', ...
    'Box', 'off');

box off;

%% Dominant-category probabilities
figure;

acrossColors = [
    0.671 0.851 0.914;
    0.129 0.443 0.710;
    0.031 0.188 0.420
];

realColor = [0.902 0.424 0.059];
fakeColor = [0.129 0.443 0.710];
barAlpha = 0.45;
hold on;

binStep = 2/24;
binEdges = 0:binStep:1;

if abs(binEdges(end) - 1) > 1e-10
    binEdges = [binEdges 1];
end

xShow = [0.2 1.0];

legendHandles = gobjects(numel(cond_names), 1);
legendText = cell(numel(cond_names), 1);

for cc = 1:numel(cond_names)

    condName = cond_names{cc};
    idxCond = strcmp(image24ProbTable.condition, condName);

    maxProb = image24ProbTable.maxCategoryProbability(idxCond);
    maxProb = maxProb(isfinite(maxProb));

    maxProb = maxProb(maxProb >= 0 & maxProb <= 1);

    if strcmp(condName, 'real')
        thisColor = realColor;
        condLabel = 'Real';
    elseif strcmp(condName, 'fake')
        thisColor = fakeColor;
        condLabel = 'Synthetic';
    else
        thisColor = [0.4 0.4 0.4];
        condLabel = condName;
    end

    h = histogram(maxProb, ...
        'BinEdges', binEdges, ...
        'Normalization', 'probability', ...
        'DisplayStyle', 'bar', ...
        'FaceColor', thisColor, ...
        'FaceAlpha', barAlpha, ...
        'EdgeColor', 'none', ...
        'LineWidth', 1.0);

    legendHandles(cc) = h;
    legendText{cc} = sprintf('%s, mean = %.2f', ...
        condLabel, mean(maxProb, 'omitnan'));

    fprintf('%s: n images = %d, min = %.3f, max = %.3f, n < 0.2 = %d\n', ...
        condLabel, numel(maxProb), min(maxProb), max(maxProb), sum(maxProb < 0.2));

end

xlabel('Dominant category response proportion');
ylabel('Proportion of images');
title('Image-level category consistency');

xlim(xShow);
xticks(0.2:0.1:1.0);
ylim([0 inf]);

set(gca, 'FontName', 'Arial', 'FontSize', 12);
box off;

legend(legendHandles, legendText, ...
    'Location', 'northwest', ...
    'Box', 'off');
