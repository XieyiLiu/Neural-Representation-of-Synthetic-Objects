% Supplementary Fig. 8d: Body, Face and Spiky patch vectors.
% Plot real and synthetic population vectors by region and recording session.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig8d_vectors.mat'));

for region_index = 1:numel(regions)
    pol_mean_all = regions(region_index).pol_mean_all;
    cat = regions(region_index).cat;
    aaa = regions(region_index).aaa;

    figure('Name',[regions(region_index).region_name ' vectors'],'NumberTitle','off');
    set(gcf,'Position',[100,531.4,548.2,368.6]);
    tp = im2uint8(colormap(slanCM('Greys')));
    cc = tp(round(linspace(80,220,size(pol_mean_all,3))),:);

    for q = 1:size(pol_mean_all,3)
        polarplot(repmat(pol_mean_all(1,1,q),10),linspace(0,pol_mean_all(2,1,q),10),'LineWidth',4,'Color',cc(q,:)); hold on;
    end

    tp = im2uint8(colormap(slanCM('Reds')));
    cc = tp(round(linspace(80,220,size(pol_mean_all,3))),:);
    for q = 1:size(pol_mean_all,3)
        polarplot(repmat(pol_mean_all(1,2,q),10),linspace(0,pol_mean_all(2,2,q),10),'LineWidth',4,'Color',cc(q,:)); hold on;
    end
    title([cat{aaa} ' area'],'FontName','Ariel','FontSize',10,'FontWeight','bold')
    set(gca,'FontName','Ariel','FontSize',10,'FontWeight','bold')
    thetaticks(0:90:360)
    rlim([0 13]);
    rticks([5 10 13]);
end
