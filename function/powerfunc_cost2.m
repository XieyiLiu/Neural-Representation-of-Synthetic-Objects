% Shared figure helper: Compute weighted squared residuals for a Weibull curve.
function minusL=powerfunc_cost2(parameters,xx,yy,e1)
lambda=parameters(1);
kk=parameters(2);

y11=1-(exp(-(xx./lambda).^kk));

minusL= sum(((y11(:)-yy(:)).^2)./(e1(:).^2));
