% Fig. 6a: behavioral space
% Average key-press probabilities across subjects to define behavioral coordinates.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig6a_behavioral_space.mat'));

clear dd
[theta,rho] = cart2pol(predimg_axis1,predimg_axis2);
theta2pi = from0to2pi(theta);
projcolor = linspace(0,2*pi,256);
for i = 1:100
    dd(:,i) = pdist2(theta2pi(i),projcolor');
end
[~,I] = min(dd);

figure;
tp = im2uint8(colormap(slanCM('twilight_s')));

pkeymean = mean(pkeyall,3);
set(gcf,'Position',[744,877,237.8,173])
for i = 1:100
    scatter(pkeymean(1,i),pkeymean(2,i),20,'MarkerFaceColor',single(squeeze(tp(I(i),:)))/255,'MarkerEdgeColor','none');hold on
end
axis square
axis([-0.1 1.1 -0.1 1.1])
xlabel('Task 1 key-press probability')
ylabel('Task 2 key-press probability')
