% Shared figure helper: Apply consistent figure, axes, text, and legend styles.
function applyFigureStyle(fig, arg2, opt)

if nargin < 1 || isempty(fig), fig = gcf; end

%% Input options
figPosIn = [];
if nargin < 3
    opt = struct();
elseif isempty(opt)
    opt = struct();
end

if nargin >= 2 && ~isempty(arg2)
    if isnumeric(arg2)
        figPosIn = arg2;
    elseif isstruct(arg2)
        opt = arg2;
    else
        error('applyFigureStyle: arg2 must be numeric (figPosIn) or struct (opt).');
    end
end

if ~isfield(opt,'fontName'),  opt.fontName  = 'Arial'; end
if ~isfield(opt,'axFont'),    opt.axFont    = 8.5; end
if ~isfield(opt,'labFont'),   opt.labFont   = 8.5; end
if ~isfield(opt,'legFont'),   opt.legFont   = 7.5; end
if ~isfield(opt,'titleFont'), opt.titleFont = 9.5; end
if ~isfield(opt,'axisLineWidth'), opt.axisLineWidth = 0.75; end
if ~isfield(opt,'noLegend'),  opt.noLegend  = false; end
if ~isfield(opt,'axisLim'),   opt.axisLim   = []; end

black = [0 0 0];

if isfield(opt,'figPosIn') && ~isempty(opt.figPosIn)
    figPosIn = opt.figPosIn;
end

if ~isempty(figPosIn)
    if ~isnumeric(figPosIn) || numel(figPosIn) ~= 4 || any(~isfinite(figPosIn))
        error('applyFigureStyle: figPosIn must be a 1x4 finite numeric vector like [x y w h] (inches).');
    end
    figPosIn = double(figPosIn(:).');
end

%% Figure settings
try
    if isprop(fig,'WindowStyle') && strcmpi(get(fig,'WindowStyle'),'docked')
        set(fig,'WindowStyle','normal');
    end
catch
end

set(fig,'Units','inches');

if ~isempty(figPosIn)
    set(fig,'Position',figPosIn);
    drawnow;
end

set(fig,'Color','w');
set(fig,'Renderer','painters');

%% Axes settings
axs = findall(fig,'Type','axes');
for k = 1:numel(axs)
    ax = axs(k);

    if strcmpi(get(ax,'Tag'),'legend')
        continue
    end

    set(ax,'FontUnits','points','FontName',opt.fontName,'FontSize',opt.axFont, ...
           'LineWidth',opt.axisLineWidth,'TickDir','in','Box','off', ...
           'XColor',black,'YColor',black);

    try, set(ax,'Color','none'); catch, end

    xl = get(ax,'XLabel'); yl = get(ax,'YLabel'); tl = get(ax,'Title');
    set([xl,yl,tl],'FontUnits','points','FontName',opt.fontName,'Color',black);

    set(xl,'FontSize',opt.labFont);
    set(yl,'FontSize',opt.labFont);
    set(tl,'FontSize',opt.titleFont,'FontWeight','normal');
end

%% Legend settings
lgds = findall(fig,'Type','legend');
if opt.noLegend
    delete(lgds);
else
    for k = 1:numel(lgds)
        lgd = lgds(k);
        set(lgd,'FontUnits','points','FontName',opt.fontName,'FontSize',opt.legFont,'Box','off');
        try, set(lgd,'TextColor',black); catch, end
    end
end

set(findall(fig,'Type','text'),'Color',black);
set(findall(fig,'-property','FontUnits'),'FontUnits','points');
set(findall(fig,'-property','FontName'),'FontName',opt.fontName);

if ~isempty(opt.axisLim)
    ax = gca;
    if isnumeric(opt.axisLim) && numel(opt.axisLim)==4 && all(isfinite(opt.axisLim))
        axis(ax, opt.axisLim);
    else
        error('applyFigureStyle: opt.axisLim must be [xmin xmax ymin ymax] finite.');
    end
end

end
