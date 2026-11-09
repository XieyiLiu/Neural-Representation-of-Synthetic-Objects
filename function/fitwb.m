% Shared figure helper: Fit a bounded Weibull curve by weighted least squares.
function [lambda,kk,RR] = fitwb(xx,yy,e1)

yff_options=optimset('TolX',1e-12,'MaxIter',6000,'TolFun',1e-12);
times= 10; linewd=1;
kk=1;
for kk=1:times
    if kk==1
        start0=rand(1,2);
    else
        start0=para0;
    end
    lb0=[20 1.4];
    ub0=[70 5];

    [para0,fval,exitflag,output]=fminsearchbnd(@(parameters)powerfunc_cost2(parameters,xx,yy,e1),[start0],lb0,ub0,yff_options);
end
lambda=para0(1);
kk=para0(2);

y_model=1-(exp(-(xx./lambda).^kk));

RR=1.0-((sum((y_model(:)-yy(:)).^2))/(sum((yy(:)-mean(yy(:))).^2)));
