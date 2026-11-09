% Fig. 6a: behavioral RDM
% Average behavioral similarities across subjects and display the RDM.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig6a_behavioral_rdm.mat'));

figure;
imagesc(1-(mean(bh,3)));
colormap(flipud(parula));axis square;
cb = colorbar;
cb.Label.String = 'Cosine dissimilarity';
