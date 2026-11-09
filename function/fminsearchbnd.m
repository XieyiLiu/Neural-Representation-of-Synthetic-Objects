% Shared figure helper: Apply bound-preserving transformations to fminsearch parameters.
% Author: John D'Errico. Release 4, 2006-07-23.
function [x,fval,exitflag,output]=fminsearchbnd3(fun,x0,LB,UB,options,varargin)

xsize = size(x0);
x0 = x0(:);
n=length(x0);

if (nargin<3) || isempty(LB)
  LB = repmat(-inf,n,1);
else
  LB = LB(:);
end
if (nargin<4) || isempty(UB)
  UB = repmat(inf,n,1);
else
  UB = UB(:);
end

if (n~=length(LB)) || (n~=length(UB))
  error 'x0 is incompatible in size with either LB or UB.'
end

if (nargin<5) || isempty(options)
  options = optimset('fminsearch');
end

params.args = varargin;
params.LB = LB;
params.UB = UB;
params.fun = fun;
params.n = n;
params.OutputFcn = [];

params.BoundClass = zeros(n,1);
for i=1:n
  k = isfinite(LB(i)) + 2*isfinite(UB(i));
  params.BoundClass(i) = k;
  if (k==3) && (LB(i)==UB(i))
    params.BoundClass(i) = 4;
  end
end

x0u = x0;
k=1;
for i = 1:n
  switch params.BoundClass(i)
    case 1

      if x0(i)<=LB(i)

        x0u(k) = 0;
      else
        x0u(k) = sqrt(x0(i) - LB(i));
      end

      k=k+1;
    case 2

      if x0(i)>=UB(i)

        x0u(k) = 0;
      else
        x0u(k) = sqrt(UB(i) - x0(i));
      end

      k=k+1;
    case 3

      if x0(i)<=LB(i)

        x0u(k) = -pi/2;
      elseif x0(i)>=UB(i)

        x0u(k) = pi/2;
      else
        x0u(k) = 2*(x0(i) - LB(i))/(UB(i)-LB(i)) - 1;

        x0u(k) = 2*pi+asin(max(-1,min(1,x0u(k))));
      end

      k=k+1;
    case 0

      x0u(k) = x0(i);

      k=k+1;
    case 4

  end

end

if k<=n
  x0u(k:n) = [];
end

if isempty(x0u)

  x = xtransform(x0u,params);

  x = reshape(x,xsize);

  fval = feval(params.fun,x,params.args{:});

  exitflag = 0;

  output.iterations = 0;
  output.funcount = 1;
  output.algorithm = 'fminsearch';
  output.message = 'All variables were held fixed by the applied bounds';

  return
end

if ~isempty(options.OutputFcn)
  params.OutputFcn = options.OutputFcn;
  options.OutputFcn = @outfun_wrapper;
end

[xu,fval,exitflag,output] = fminsearch(@intrafun,x0u,options,params);

x = xtransform(xu,params);

x = reshape(x,xsize);

  function stop = outfun_wrapper(x,varargin);

    xtrans = xtransform(x,params);

    stop = params.OutputFcn(xtrans,varargin{1:(end-1)});

  end

end

%% Local functions

function fval = intrafun(x,params)

xtrans = xtransform(x,params);

fval = feval(params.fun,xtrans,params.args{:});

end

function xtrans = xtransform(x,params)

xtrans = zeros(1,params.n);

k=1;
for i = 1:params.n
  switch params.BoundClass(i)
    case 1

      xtrans(i) = params.LB(i) + x(k).^2;

      k=k+1;
    case 2

      xtrans(i) = params.UB(i) - x(k).^2;

      k=k+1;
    case 3

      xtrans(i) = (sin(x(k))+1)/2;
      xtrans(i) = xtrans(i)*(params.UB(i) - params.LB(i)) + params.LB(i);

      xtrans(i) = max(params.LB(i),min(params.UB(i),xtrans(i)));

      k=k+1;
    case 4

      xtrans(i) = params.LB(i);
    case 0

      xtrans(i) = x(k);

      k=k+1;
  end
end

end
