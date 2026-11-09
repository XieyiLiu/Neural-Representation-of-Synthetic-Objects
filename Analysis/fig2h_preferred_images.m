% Fig. 2h
% Display synthetic images selected by ROI preference.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig2h_preferred_images.mat'));

for hh = 1:length(ROIall)
    figure;
    for i = 1:6
        subplot(3,2,i)
        imagesc(img100_fake(:,:,ids(i,hh)));
        axis image off
        colormap gray
    end
    sgtitle(['Synthetic objects (' char(ROIall(hh)) ')'])
end
