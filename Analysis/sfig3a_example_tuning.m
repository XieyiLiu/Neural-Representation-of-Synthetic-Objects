% Supplementary Fig. 3a
% Fit single- and double-peak von Mises models using bounded multistart optimization.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig3a_example_tuning.mat'));

rng(random_state);

vm1 = @(p,t) p(1)*exp(p(3)*cos(t - p(2))) + p(4);

vm2 = @(p,t) ...
    p(1)*exp(p(3)*cos(t - p(2))) + ...
    p(4)*exp(p(6)*cos(t - p(5))) + p(7);

lb1 = double([0,    0,    0,   -Inf]);
ub1 = double([Inf,  2*pi, Inf,  Inf]);

lb2 = double([0,    0,    0,    0,    0,    0,   -Inf]);
ub2 = double([Inf,  2*pi, Inf,  Inf,  2*pi, Inf,  Inf]);
opts=optimoptions('lsqcurvefit','Display','off','MaxFunctionEvaluations',2e4,'MaxIterations',2e3);
nStart2=10;
valid=~isnan(pval);qval=nan(size(pval));qval(valid)=mafdr(pval(valid),'BHFDR',true);
figure;set(gcf,'Position',[553 513.8 938.4 316.8]);
xfit=linspace(0,2*pi,300); fitted_curves=zeros(300,2,2);
for v=1:2
 y_raw=beta_examples(:,v); ok=~isnan(y_raw); x=theta(ok);y=zscore(y_raw(ok));
 [p1,p2]=fit_von_mises_example(x,y,vm1,vm2,lb1,ub1,lb2,ub2,opts,nStart2);
 fitted_curves(:,1,v)=vm1(p1,xfit);fitted_curves(:,2,v)=vm2(p2,xfit);
 subplot(1,2,v);hold on;
 plot(x,y,'.','Color',[0.6 0.6 0.6],'MarkerSize',10);
 plot(xfit,fitted_curves(:,1,v),'LineWidth',2.5,'Color',[0.2 0.4 0.8]);
 plot(xfit,fitted_curves(:,2,v),'LineWidth',2.5,'Color',[0.8 0.2 0.2]);
 xlabel('\theta (radians)');ylabel('z-scored response');title(sprintf('Example vertex %d',v));
 legend({'Data','Unimodal','Bimodal'},'Box','off','Location','best');box off;
 text(0.05,0.9,sprintf('q(FDR)=%.3g',qval(vertex_ids(v))),'Units','normalized','FontWeight','bold','FontSize',10);
end
