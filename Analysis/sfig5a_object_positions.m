% Supplementary Fig. 5a: object positions
% Compute category entropy and plot object-space positions.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig5a_object_positions.mat'));

H_norm=zeros(100,1);
for i=1:100
 p=numcount(i,:)/sum(numcount(i,:));p=p(p>0);
 H_norm(i)=-sum(p.*log2(p))/log2(size(numcount,2));
end
[H_norm_sort,id]=sort(H_norm,'ascend');
img_id_sorted=new_img_survery_num(id);
id_lackall_sort=img_id_sorted(end-49:end);
idx_red=ismember(img_id_sorted,id_lackall_sort);
base_color=[0.40 0.80 0.67];highlight_color=[0.10 0.20 0.40];
figure('Position',[100 100 800 450]);
x = predimg_axis1(:);
y = predimg_axis2(:);

theta = atan2(y, x);
theta(theta < 0) = theta(theta < 0) + 2*pi;

r = sqrt(x.^2 + y.^2);

ax = axes; hold on;
axis equal; axis square;
set(gca,'box','off')
axis([-30 30 -30 30])

red_idx  = id_lackall_sort(:)';
blue_idx = setdiff(1:100, red_idx);

[px_b, py_b] = pol2cart(theta(blue_idx), r(blue_idx));
h_blue = plot(px_b, py_b,'Marker','.', 'MarkerSize', 17, 'Color',base_color,'LineStyle', 'none');
[px_r, py_r] = pol2cart(theta(red_idx), r(red_idx));
h_red = plot(px_r, py_r,'Marker','.', 'MarkerSize', 17,'Color',highlight_color,'LineStyle', 'none');

xlabel('Axis 1');
ylabel('Axis 2');

legend([h_red, h_blue], ...
    {'Low (50 synthetic objects)', ...
     'High (50 synthetic objects)'},'Location','eastoutside');
legend box off
hold off;
