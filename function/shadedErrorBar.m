% Shared figure helper: Plot a line with a shaded error band.
% Rob Campbell, 2009. See licenses/shadedErrorBar_LICENSE.txt.
function varargout=shadedErrorBar(x,y,errBar,varargin)

%% Input options
narginchk(3,inf)

params = inputParser;
params.CaseSensitive = false;
params.addParameter('lineProps', '-k', @(x) ischar(x) | iscell(x));
isOctave = exist('OCTAVE_VERSION','builtin') ~= 0;
params.addParameter('transparent', ~isOctave, @(x) islogical(x) || x==0 || x==1);
params.addParameter('patchSaturation', 0.2, @(x) isnumeric(x) && x>=0 && x<=1);

params.parse(varargin{:});

lineProps =  params.Results.lineProps;
transparent =  params.Results.transparent;
patchSaturation = params.Results.patchSaturation;

if ~iscell(lineProps), lineProps={lineProps}; end

if iscell(errBar)
    fun1=errBar{1};
    fun2=errBar{2};
    errBar=fun2(y);
    y=fun1(y);
else
    y=y(:).';
end

if isempty(x)
    x=1:length(y);
elseif ~isOctave
    x=x(:).';
end

if length(errBar)==length(errBar(:))
    errBar=repmat(errBar(:)',2,1);
else
    s=size(errBar);
    f=find(s==2);
    if isempty(f), error('errBar has the wrong size'), end
    if f==2, errBar=errBar'; end
end

if length(x) ~= length(errBar)
    if ~isOctave
        error('length(x) must equal length(errBar)')
    elseif ~checkOctave_datestr(x)
        error('length(x) must equal length(errBar) or x must have valid datestr')
    end
end

initialHoldStatus=ishold;
if ~initialHoldStatus, hold on,  end

H = makePlot(x,y,errBar,lineProps,transparent,patchSaturation,isOctave);

if ~initialHoldStatus, hold off, end

if nargout==1
    varargout{1}=H;
end

function H = makePlot(x,y,errBar,lineProps,transparent,patchSaturation,isOctave)

    %% Error-band plot

    if ~isOctave
      H.mainLine=plot(x,y,lineProps{:});

    else
      boolxDatestr = checkOctave_datestr(x);
      if boolxDatestr
        x = datenum(x);
        x = x(:).';
        H.mainLine=plot(x,y,lineProps{:});
        datetick(gca);
      else
        H.mainLine=plot(x,y,lineProps{:});
      end
    end

    H.mainLine.Tag = 'shadedErrorBar_mainLine';

    mainLineColor=get(H.mainLine,'color');
    edgeColor=mainLineColor+(1-mainLineColor)*0.55;

    if transparent
        faceAlpha=patchSaturation;
        patchColor=mainLineColor;
    else
        faceAlpha=1;
        patchColor=mainLineColor+(1-mainLineColor)*(1-patchSaturation);
    end

    uE=y+errBar(1,:);
    lE=y-errBar(2,:);

    yP=[lE,fliplr(uE)];
    xP=[x,fliplr(x)];

    xP(isnan(yP))=[];
    yP(isnan(yP))=[];

    if ~isOctave && isdatetime(x)
      H.patch=patch(datenum(xP),yP,1);
    else
      H.patch=patch(xP,yP,1);
    end

    set(H.patch,'facecolor',patchColor, ...
        'edgecolor','none', ...
        'facealpha',faceAlpha, ...
        'HandleVisibility', 'off', ...
        'Tag', 'shadedErrorBar_patch')

    H.edge(1)=plot(x,lE,'-');
    H.edge(2)=plot(x,uE,'-');

    set([H.edge], 'color',edgeColor, ...
      'HandleVisibility','off', ...
      'Tag', 'shadedErrorBar_edge')

    if ~isOctave
      if strcmp(get(gca,'YAxisLocation'),'left')
        uistack(H.mainLine,'top')
      end
    else

      H = struct('mainLine', H.mainLine, ...
      'patch', H.patch, ...
      'edge', H.edge);
    end

function boolDate = checkOctave_datestr(x)

  boolDate = true;
  try
    datenum(x)
  catch
    boolDate = false;
  end
