% Fig. 7a: frontal and parietal MDS and RDM.
% Plot MDS coordinates and RDMs for frontal and parietal cortex.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig7a_representational_geometry.mat'));

for region_index=1:numel(regions)
    Y=regions(region_index).Y;
    rb=regions(region_index).rb;
    ROIname=regions(region_index).ROIname;
    allROI=regions(region_index).allROI;
    hh=regions(region_index).hh;

figMDS = figure;
    set(figMDS,'Position',[10,10,700,550],'Renderer','painters');
    hTask1 = scatter3(Y(1:100,1),Y(1:100,2),-Y(1:100,3), ...
        35,'b','filled'); hold on
    hTask2 = scatter3(Y(101:200,1),Y(101:200,2),-Y(101:200,3), ...
        35,'r','filled');
    hPV = scatter3(Y(201:300,1),Y(201:300,2),-Y(201:300,3), ...
        35,'k','filled');
    xlabel('MDS dim1'); ylabel('MDS dim2'); zlabel('MDS dim3')
    legend([hTask1,hTask2,hPV],{'Task 1','Task 2','PV'});
    legend boxoff
    title([upper(ROIname(1)) ROIname(2:end)]);
    set(gca,'FontName','Tahoma','FontSize',12,'FontWeight','bold')
    view(3)
    grid on
    axis vis3d

    if ismember(allROI{hh}, {'frontal4', 'parietal2'})

        xyz = [Y(:,1), Y(:,2), -Y(:,3)];
        groupIndex = {1:100, 101:200, 201:300};
        overallMean = mean(xyz, 1);
        withinScatter = zeros(3);
        betweenScatter = zeros(3);
        for groupNumber = 1:numel(groupIndex)
            groupData = xyz(groupIndex{groupNumber}, :);
            groupMean = mean(groupData, 1);
            centeredGroup = groupData - groupMean;
            withinScatter = withinScatter + centeredGroup' * centeredGroup;
            meanDifference = (groupMean - overallMean)';
            betweenScatter = betweenScatter + numel(groupIndex{groupNumber}) * ...
                (meanDifference * meanDifference');
        end
        regularization = max(trace(withinScatter), 1) * 1e-10;
        [discriminantVectors, discriminantValues] = eig( ...
            betweenScatter, withinScatter + regularization * eye(3));
        [~, discriminantOrder] = sort(diag(discriminantValues), 'descend');
        discriminantPlane = discriminantVectors(:, discriminantOrder(1:2));
        viewingDirection = cross(discriminantPlane(:,1), discriminantPlane(:,2));
        viewingDirection = viewingDirection ./ norm(viewingDirection);
        if viewingDirection(3) < 0
            viewingDirection = -viewingDirection;
        end

        view(gca, viewingDirection);
        camup(gca, [0 0 1]);
        axis vis3d
        drawnow
end

figure;
    set(gcf,'Position',[541.8000000000001,429.8,560.0000000000001,447.2]);
    imagesc(1-rb, [0,1]);
    colormap(flipud(jet))
    cb = colorbar; cb.Label.String = 'Dissimilarity';
    set(gca,'XTick',[50.5 150.5 250.5],'YTick',[50.5 150.5 250.5], ...
        'XTickLabel',{'Task 1','Task 2','PV'},'YTickLabel',{'Task 1','Task 2','PV'});
    title([upper(ROIname(1)) ROIname(2:end)]);
    set(gca,'FontName','Times New Roman','FontSize',12,'FontWeight','bold')
end
