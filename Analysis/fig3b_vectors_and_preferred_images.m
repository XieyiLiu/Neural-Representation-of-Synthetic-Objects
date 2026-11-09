% Fig. 3b / Supplementary Fig. 8b: vectors and preferred images
% Plot population vectors and preferred images for Body, Face, and Spiky regions.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig3b_vectors_and_preferred_images.mat'));

for aaa=1:numel(cat)
    pol_mean_all=pol_mean_by_region{aaa};
figure;
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
    rlim([0 12]);
    rticks([5 10 12]);
end

figure;
set(gcf,'Position',[100 100 1100 400]);

for nn = 1:length(cat)
    id = top9(nn,:);

    imgshow = showimg_mat(img100_fake,id(1:9),0);
    subplot(1,3,nn)
    imshow(imgshow)
    title(['Top 9 synthetic objects (' cat{nn} ')'])
end
