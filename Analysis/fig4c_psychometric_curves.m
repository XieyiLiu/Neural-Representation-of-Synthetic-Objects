% Fig. 4c
% Fit bounded Weibull curves to behavioral response probabilities.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig4c_psychometric_curves.mat'));

rng(407,'twister');

figure;
set(gcf,'Position',[668.2,222.6,1099.2,724.8000000000001])
subplot(1,2,1)
xx=meanaxis1_cutaxis+(-min(meanaxis1_cutaxis));
yy=mean(accaxis1(1,:,:),3);
e1=std(squeeze(accaxis1(1,:,:))')/sqrt(length(subjall));
[lambda,kk,RR] = fitwb(xx(:),yy(:),e1(:));
xxx=(0:0.01:max(meanaxis1_cutaxis)+(-min(meanaxis1_cutaxis)));
y_fit = 1-(exp(-(xxx./lambda).^kk));
xt = linspace(0,50,length(1:30:length(y_fit)));
plot(xt,y_fit(1:30:length(y_fit)),'-','LineWidth',3.5);hold on
plot(xx,yy,'LineStyle','none','Marker','.','MarkerFaceColor','r','MarkerSize',20);hold on
errorbar(xx,yy,e1,'.','LineWidth',1.5,'color',[0.85,0.33,0.10],'HandleVisibility','off')
b = vpa(RR,2);
text(7,0.8,['R^2 = ' char(b)],"FontSize",12,'FontWeight','normal')
title('Task 1','FontName','Arial','FontSize',10,'FontWeight','normal');
set(gca,'FontName','Arial','FontSize',10,'FontWeight','normal');
xlabel('Axis 1');
ylabel('Probability to choose positive in axis 1')
axis([0 50 0 1]);
% Show signed object-space coordinates for the shifted Weibull fit.
signedTicks = -25:10:25;
tickPositions = signedTicks - min(meanaxis1_cutaxis);
xlim([min(0,tickPositions(1)), max(50,tickPositions(end))]);
xticks(tickPositions); xticklabels(string(signedTicks));
axis square
box off

subplot(1,2,2)
xx=meanaxis2_cutaxis+(-min(meanaxis2_cutaxis));
yy=mean(accaxis2(2,:,:),3);
e1=std(squeeze(accaxis2(2,:,:))')/sqrt(length(subjall));
[lambda,kk,RR] = fitwb(xx(:),yy(:),e1(:));
xxx=(0:0.01:max(meanaxis2_cutaxis)+(-min(meanaxis2_cutaxis)));
y_fit = 1-(exp(-(xxx./lambda).^kk));
xt = linspace(0,50,length(1:30:length(y_fit)));
plot(xt,y_fit(1:30:length(y_fit)),'-','LineWidth',3.5);hold on
plot(xx,yy,'LineStyle','none','Marker','.','MarkerFaceColor','r','MarkerSize',20);hold on
errorbar(xx,yy,e1,'.','LineWidth',1.5,'color',[0.85,0.33,0.10],'HandleVisibility','off')
b = vpa(RR,2);
text(7,0.8,['R^2 = ' char(b)],"FontSize",12,'FontWeight','normal')
title('Task 2','FontName','Arial','FontSize',10,'FontWeight','normal');
set(gca,'FontName','Arial','FontSize',10,'FontWeight','normal');
xlabel('Axis 2');
ylabel('Probability to choose positive in axis 2')
axis([0 50 0 1]);
% Show signed object-space coordinates for the shifted Weibull fit.
signedTicks = -25:10:25;
tickPositions = signedTicks - min(meanaxis2_cutaxis);
xlim([min(0,tickPositions(1)), max(50,tickPositions(end))]);
xticks(tickPositions); xticklabels(string(signedTicks));
axis square
box off
