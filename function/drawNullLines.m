% Shared figure helper: Draw permutation-null mean and percentile reference lines.
function [hMean, hP95] = drawNullLines(x, nullMean, nullP95, barWidth, grey, showInLegend)

if nargin < 6
    showInLegend = false;
end

lineWidth = barWidth * 0.9;
xL = x - lineWidth / 2;
xR = x + lineWidth / 2;

hMean = plot([xL xR], [nullMean nullMean], '-', ...
    'Color', grey, 'LineWidth', 1.8);
hP95 = plot([xL xR], [nullP95 nullP95], '--', ...
    'Color', grey, 'LineWidth', 1.5);

if showInLegend
    hMean.DisplayName = 'Null mean';
    hP95.DisplayName = 'Null 95th percentile';
else
    hMean.HandleVisibility = 'off';
    hP95.HandleVisibility = 'off';
end
end
