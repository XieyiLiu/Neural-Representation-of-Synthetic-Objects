% Fig. 4d
% Summarize task accuracy across subjects.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig4d_accuracy.mat'));

figure;
set(gcf,'Position',[1262.6,527.4,504.8,420])
data = mean(squeeze(mean(accall,2)),2)*100;
se = std(squeeze(mean(accall,2))')/sqrt(length(subjall))*100;
bar(1,data(1),'BarWidth',0.5,'FaceColor',[0 0 1],'EdgeColor','none');hold on
errorbar(1,data(1),se(1),'LineWidth',2,'Color',[0.5 0.5 0.5]);hold on
bar(1.7,data(2),'BarWidth',0.5,'FaceColor',[1 0 0],'EdgeColor','none');hold on
errorbar(1.7,data(2),se(2),'LineWidth',2,'Color',[0.5 0.5 0.5]);hold on
bar(2.4,data(3),'BarWidth',0.5,'FaceColor',[0 0 0],'EdgeColor','none');hold on
errorbar(2.4,data(3),se(3),'LineWidth',2,'Color',[0.5 0.5 0.5]);hold on
acc_subj = squeeze(mean(accall,2))*100;
x_jitter = linspace(-0.2,0.2,length(subjall));
scatter(1+x_jitter,acc_subj(1,:),20,'MarkerFaceColor','w','MarkerEdgeColor',[0 0 1],'LineWidth',1.2);hold on
scatter(1.7+x_jitter,acc_subj(2,:),20,'MarkerFaceColor','w','MarkerEdgeColor',[1 0 0],'LineWidth',1.2);hold on
scatter(2.4+x_jitter,acc_subj(3,:),20,'MarkerFaceColor','w','MarkerEdgeColor',[0 0 0],'LineWidth',1.2);hold on
box off
set(gca,'XTick',[1 1.7 2.4],'XTickLabel',{'Task 1','Task 2','PV'},'FontName','Arial','FontSize',10,'FontWeight','normal')
ylabel('Accuracy (%)')
ylim([0 100])
axis square
