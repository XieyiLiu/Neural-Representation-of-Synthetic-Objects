% Supplementary Fig. 4c-d: ROI responses and preferred images.
% Select preferred images and summarize ROI responses with SEM.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig4cd_roi_responses_and_images.mat'));

%% ROI responses

bar_lack_all = zeros(length(ROIall),1);
bar_beta_all = zeros(length(ROIall),1);
img_lack_top = cell(length(ROIall),1);
bar_img_values = nan(6,numel(ROIall),3);
for hh=1:numel(ROIall)
beta=beta_by_roi(:,hh);
    y_lack_low = beta(id_low, 1);
    y_lack_high = beta(setdiff(1:100,id_low), 1);
    id_rich = setdiff(1:100,id_low);

    [y_lack_sorted, idy_lack] = sort(y_lack_low,'descend');
    [y_rich_sorted, idy_rich] = sort(y_lack_high,'descend');
    [beta_sorted, idbeta] = sort(beta(:,1),'descend');
    bar_lack_all(hh) = mean(y_lack_sorted(1:6));
    bar_lack_all_error(hh) = std(y_lack_sorted(1:6))/sqrt(6);
    bar_beta_all(hh) = mean(beta_sorted(1:6));
    bar_beta_all_error(hh) = std(beta_sorted(1:6))/sqrt(6);
    bar_rich_all(hh) = mean(y_rich_sorted(1:6));
    bar_rich_all_error(hh) = std(y_rich_sorted(1:6))/sqrt(6);

bar_img_values(:,hh,1) = reshape(y_lack_sorted(1:6),[],1);
bar_img_values(:,hh,2) = reshape(y_rich_sorted(1:6),[],1);
bar_img_values(:,hh,3) = reshape(beta_sorted(1:6),[],1);

    img_lack_top{hh,1} = id_low(idy_lack(1:6));
    img_lack_top{hh,2} = idbeta(1:6);
    img_lack_top{hh,3} = id_rich(idy_rich(1:6));

end

figure;
set(gcf,'Position',[100,100,920,450])
bar_data = [bar_lack_all , bar_rich_all' ,bar_beta_all];

b = bar(bar_data,'grouped');
b(1).FaceColor = [0.10 0.20 0.40];
b(2).FaceColor = [0.40 0.80 0.67];
b(3).FaceColor = [0.5 0.5 0.5];
set(b,'EdgeColor','none');

hold on

x = nan(3, size(bar_data,1));
for i = 1:3
    x(i,:) = b(i).XEndPoints;
end

errorbar(x(1,:), bar_lack_all, bar_lack_all_error, ...
    'k', 'LineStyle','none', 'LineWidth',1.2)

errorbar(x(2,:), bar_rich_all, bar_rich_all_error, ...
    'k', 'LineStyle','none', 'LineWidth',1.2)

errorbar(x(3,:), bar_beta_all, bar_beta_all_error, ...
    'k', 'LineStyle','none', 'LineWidth',1.2)

offset = linspace(-0.08,0.08,6);

for gg = 1:3
    for rr = 1:numel(ROIall)
        yimg = reshape(bar_img_values(:,rr,gg),1,[]);

        scatter(x(gg,rr) + offset, yimg, 18, ...
            'MarkerFaceColor','white', ...
            'MarkerEdgeColor',b(gg).FaceColor, ...
            'LineWidth',0.8, ...
            'HandleVisibility','off');
    end
end

hold off

set(gca,'XTick',1:4,'XTickLabel',ROIall)
ylabel('Mean response to top 6 images')
ylim('auto')
legend(b,{'Low (50 synthetic objects)','High (50 synthetic objects)','100 synthetic objects'}, ...
    'Location','northeastoutside','AutoUpdate','off');
legend box off
box off

%% Preferred images
figure;
set(gcf,'Position',[100 100 1000 500]);
for hh=1:numel(ROIall)
 for gg=1:2
  subplot(2,4,(gg-1)*4+hh);
  idx=img_lack_top{hh,1+2*(gg-1)};
  montage(uint8(reshape(img100_fake(:,:,idx),size(img100_fake,1),size(img100_fake,2),1,[])),'Size',[2 3]);
  if gg==1, label='Low';else,label='High';end
  title([ROIall{hh} ' ' label]);
 end
end
