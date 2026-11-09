% Shared figure helper: Draw a shaded chance range and reference line.
function drawChancePatchLine(x, mu, lo, hi, barWidth, ciShrink, grey, alphaCI)

    lo2 = mu + ciShrink*(lo - mu);
    hi2 = mu + ciShrink*(hi - mu);

    xL = x - barWidth/2;
    xR = x + barWidth/2;
    patch([xL xR xR xL], [lo2 lo2 hi2 hi2], grey, ...
        'EdgeColor','none', 'FaceAlpha',alphaCI, 'HandleVisibility','off');

    plot([xL xR], [mu mu], '-', 'Color',grey, 'LineWidth',2.0, ...
        'HandleVisibility','off');
end
