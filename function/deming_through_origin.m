% Shared figure helper: Fit a zero-intercept Deming slope using weighted orthogonal residuals.
function b = deming_through_origin(x,y,lambda)

x = x(:); y = y(:);
ok = isfinite(x) & isfinite(y);
x = x(ok); y = y(ok);

if nargin < 3 || isempty(lambda)
    lambda = 1;
end

obj = @(b) deming_obj_origin(b,x,y,lambda);
b = fminsearch(obj, 0);
end

function val = deming_obj_origin(b,x,y,lambda)

val = sum( (y - b*x).^2 ./ (1 + (b^2)/lambda) );
end
