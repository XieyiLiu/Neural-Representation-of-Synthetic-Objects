% Supplementary Fig. 5a: entropy distribution
% Compute normalized Shannon entropy from category-response counts.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig5a_entropy.mat'));

H_norm=zeros(100,1);
for i=1:100
 p=numcount(i,:)/sum(numcount(i,:));p=p(p>0);
 H_norm(i)=-sum(p.*log2(p))/log2(size(numcount,2));
end
[H_norm_sort,id]=sort(H_norm,'ascend');
img_id_sorted=new_img_survery_num(id);
id_lackall_sort=img_id_sorted(end-49:end);
idx_red=ismember(img_id_sorted,id_lackall_sort);
figure;
set(gcf,'Position',[672.2,783.4000000000001,967.2,213.6])
b = bar(1:100, H_norm_sort);
hold on;

b.FaceColor = 'flat';
b.EdgeColor = 'none';

base_color = [0.40 0.80 0.67];
highlight_color = [0.10 0.20 0.40];

b.CData = repmat(base_color, 100, 1);
b.CData(idx_red, :) = repmat(highlight_color, sum(idx_red), 1);

box off;
xlabel('Entropy rank');
ylabel('Normalized entropy');
set(gca,'TickDir','out')

h1 = bar(nan, nan, 'FaceColor', base_color, 'EdgeColor', 'none');
h2 = bar(nan, nan, 'FaceColor', highlight_color, 'EdgeColor', 'none');

legend([h2, h1], {'Low (50 synthetic objects)', 'High (50 synthetic objects)'}, ...
    'Location', 'northoutside', 'Orientation', 'horizontal', 'Box', 'off');
