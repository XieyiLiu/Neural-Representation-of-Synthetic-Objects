% Supplementary Fig. 1d: stimulus positions.
% Plot real and synthetic stimulus coordinates and the selected real-object subset.
package_dir = fileparts(fileparts(mfilename('fullpath')));
load(fullfile(package_dir, 'Source_Data', 'sfig1d_stimulus_positions.mat'));
figure('Position',[100 100 880 430]);
subplot(1,2,1)
scatter(sc1,sc2,8,'filled','MarkerFaceColor',[0.5 0.5 0.5]);hold on
scatter(predimg_axis1,predimg_axis2,8,'red','filled');hold on
plot([-80 80],[0 0],'k','LineWidth',1);hold on
plot([0 0],[-80 80],'k','LineWidth',1);hold on
axis([-80 80 -80 80])
legend('500 real objects','100 synthetic objects','FontName','Arial','FontSize',10,'Location','northoutside','Box','off')
legend('boxoff')
axis off
axis square

subplot(1,2,2)
scatter(sc1,sc2,8,'filled','MarkerFaceColor',[0.5 0.5 0.5]);hold on
scatter(sc11,sc22,8,'blue','filled');hold on
scatter(predimg_axis1,predimg_axis2,8,'red','filled');hold on
plot([-80 80],[0 0],'k','LineWidth',1);hold on
plot([0 0],[-80 80],'k','LineWidth',1);hold on
axis([-80 80 -80 80])
legend('500 real objects','100 real objects','100 synthetic objects','FontName','Arial','FontSize',10,'Location','northoutside','Box','off')
legend('boxoff')
axis off
axis square
