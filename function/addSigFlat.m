% Shared figure helper: Draw a significance bracket and label.
function addSigFlat(x1, x2, y, txt)

    if isnumeric(txt)
        p = txt;
        if ~isfinite(p) || p >= 0.05
            return;
        end
        if p == 0
            txt = '\itp\rm < 0.001';
        else
            parts = strsplit(sprintf('%.2e',p),'e');
            txt = sprintf('\\itp\\rm = %s\\times10^{%d}',parts{1},str2double(parts{2}));
        end
    end
    plot([x1 x2], [y y], 'k', 'LineWidth',1.2, 'HandleVisibility','off');
    text(mean([x1 x2]), y+0.008, txt, 'HorizontalAlignment','center', ...
        'VerticalAlignment','bottom', 'FontName','Arial','FontSize',9,'FontWeight','normal', ...
        'HandleVisibility','off');
end
