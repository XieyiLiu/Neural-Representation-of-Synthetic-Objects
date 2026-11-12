% Fig. 5d-f: cross-condition RDM, 3-D MDS, and within-condition MDS.
% Cross-condition RDMs, MDS, and paired tests of correlations and distances.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig5def_representational_geometry.mat'));

%% Fig. 5d: cross-condition RDM

rng(407,'twister');

    figure;
    set(gcf,'Position',[541.8000000000001,429.8,560.0000000000001,447.2]);
    imagesc(1-rb, [0,0.7]);
    colormap(flipud(jet))
    cb = colorbar; cb.Label.String = 'Dissimilarity';
    set(gca,'XTick',[50.5 150.5 250.5],'YTick',[50.5 150.5 250.5], ...
        'XTickLabel',{'Task 1','Task 2','PV'},'YTickLabel',{'Task 1','Task 2','PV'});
    title('VTC');
    set(gca,'FontName','Times New Roman','FontSize',12,'FontWeight','bold')

%% Same-stimulus correlations
% Average over stimuli within each participant before comparing condition pairs.
r_task1_task2 = mean(r_t1t2,1);
r_task1_pv = mean(r_t1pv,1);
r_task2_pv = mean(r_t2pv,1);
mean_same_object_r = [mean(r_task1_task2), mean(r_task1_pv), mean(r_task2_pv)];

fprintf('\nFig. 5d | Same-stimulus correlations across conditions (PV = passive viewing)\n');
fprintf('Group mean Pearson r (%d stimuli per participant, n = %d participants)\n', ...
    size(r_t1t2,1), size(r_t1t2,2));
fprintf('  Task 1 / Task 2 = %.2f, Task 1 / PV = %.2f, Task 2 / PV = %.2f\n', ...
    mean_same_object_r);
fprintf('Two-sided paired t-tests across participants\n');
report_paired_ttest('r(Task 1, Task 2) vs r(Task 1, PV)', r_task1_task2, r_task1_pv);
report_paired_ttest('r(Task 1, Task 2) vs r(Task 2, PV)', r_task1_task2, r_task2_pv);
fprintf('Additional comparison\n');
[h,p,ci,stats] = report_paired_ttest('r(Task 2, PV) vs r(Task 1, PV)', r_task2_pv, r_task1_pv);

%% Fig. 5e: three-dimensional MDS
Yplot = [Y(:,1), Y(:,2), -Y(:,3)];
    classLabel = [ones(200,1); -ones(100,1)];
    svmModel = fitcsvm(Yplot, classLabel, ...
        'KernelFunction','linear', ...
        'Standardize',false, ...
        'Prior','uniform', ...
        'ClassNames',[-1,1]);

    predictedLabel = predict(svmModel, Yplot);
    apparentAccuracy = mean(predictedLabel == classLabel);
    fprintf('\nFig. 5e | VTC 3-D MDS\n');
    fprintf('  Task-vs-PV linear-plane apparent accuracy = %.4f\n', apparentAccuracy);

    lowerLimit = min(Yplot,[],1);
    upperLimit = max(Yplot,[],1);
    limitPadding = 0.05 * max(upperLimit - lowerLimit, eps);
    plotLimits = [lowerLimit - limitPadding; upperLimit + limitPadding]';

    figMDS = figure;
    set(figMDS,'Position',[10,10,700,550]);
    hTask1 = scatter3(Yplot(1:100,1),Yplot(1:100,2),Yplot(1:100,3), ...
        35,'b','filled'); hold on
    hTask2 = scatter3(Yplot(101:200,1),Yplot(101:200,2),Yplot(101:200,3), ...
        35,'r','filled');
    hPV = scatter3(Yplot(201:300,1),Yplot(201:300,2),Yplot(201:300,3), ...
        35,'k','filled');

    hPlane = plot_linear_svm_plane(svmModel.Beta, svmModel.Bias, plotLimits);

    xlabel('MDS dim1'); ylabel('MDS dim2'); zlabel('MDS dim3')
    legend([hTask1,hTask2,hPV],{'Task 1','Task 2','PV'});
    legend boxoff
    title('VTC');
    set(gca,'FontName','Tahoma','FontSize',12,'FontWeight','bold')
    xlim(plotLimits(1,:));
    ylim(plotLimits(2,:));
    zlim(plotLimits(3,:));
    view(3)
    grid on
    axis vis3d

%% Fig. 5f: within-condition MDS

rng(407,'twister');

tp=im2uint8(slanCM('twilight_s'));ccmap(:,1,:)=tp;
Y1=mdscale(squareform(1-rb_task1),2);Y2=mdscale(squareform(1-rb_task2),2);Y3=mdscale(squareform(1-rb_pv),2);
    figure;
    subplot(1,3,1)
    set(gcf,'Position',[10,10,700,550]);
    ci = linspace(1,256,100);
    for i = 1:100
        scatter(Y1(i,1),Y1(i,2),35,'MarkerFaceColor',single(squeeze(ccmap(I(i),:,:))')/255,'MarkerEdgeColor',single(squeeze(ccmap(fix(ci(i)),:,:))')/255);hold on
    end
    axis([-0.4 0.4 -0.4 0.4]);axis off;axis square;
    xlabel('MDS dim1');ylabel('MDS dim2')
    title('VTC (Task 1)');
    set(gca,'FontName','Tahoma','FontSize',12,'FontWeight','bold')

    subplot(1,3,2)
    set(gcf,'Position',[10,10,700,550]);
    ci = linspace(1,256,100);
    for i = 1:100
        scatter(Y2(i,1),Y2(i,2),35,'MarkerFaceColor',single(squeeze(ccmap(I(i),:,:))')/255,'MarkerEdgeColor',single(squeeze(ccmap(fix(ci(i)),:,:))')/255);hold on
    end
    axis([-0.4 0.4 -0.4 0.4]);axis off;axis square;
    xlabel('MDS dim1');ylabel('MDS dim2')
    title('VTC (Task 2)');
    set(gca,'FontName','Tahoma','FontSize',12,'FontWeight','bold')

    subplot(1,3,3)
    set(gcf,'Position',[10,10,700,550]);
    ci = linspace(1,256,100);
    for i = 1:100
        scatter(Y3(i,1),Y3(i,2),35,'MarkerFaceColor',single(squeeze(ccmap(I(i),:,:))')/255,'MarkerEdgeColor',single(squeeze(ccmap(fix(ci(i)),:,:))')/255);hold on
    end
    axis([-0.4 0.4 -0.4 0.4]);axis off;axis square;
    xlabel('MDS dim1');ylabel('MDS dim2')
    title('VTC (PV)');
    set(gca,'FontName','Tahoma','FontSize',12,'FontWeight','bold')
% Rows of dtall correspond to Task 1, Task 2 and PV; columns are participants.
mean_subject_distance = mean(dtall,2);
fprintf('\nFig. 5f | Mean pairwise Euclidean distances in 2-D MDS\n');
fprintf('Group means of participant-level distances (n = %d participants)\n', size(dtall,2));
fprintf('  Task 1 = %.2f, Task 2 = %.2f, PV = %.2f\n', mean_subject_distance);
fprintf('Two-sided paired t-tests across participants\n');
report_paired_ttest('Task 1 vs Task 2', dtall(1,:), dtall(2,:));
report_paired_ttest('Task 1 vs PV', dtall(1,:), dtall(3,:));
[~,p,~,stats] = report_paired_ttest('Task 2 vs PV', dtall(2,:), dtall(3,:));

fprintf('Descriptive distances in the three displayed group embeddings\n');
fprintf('  Task 1 = %.4f, Task 2 = %.4f, PV = %.4f\n', ...
    mean(pdist(Y1,'euclidean')), mean(pdist(Y2,'euclidean')), mean(pdist(Y3,'euclidean')));

function [h,p,ci,stats] = report_paired_ttest(label, first, second)
    [h,p,ci,stats] = ttest(first, second, 'Tail','both');
    fprintf('  %-36s  t(%d) = %.2f, p = %.3g\n', label, stats.df, stats.tstat, p);
end

function hPlane = plot_linear_svm_plane(w, b, plotLimits)

w = w(:);
binaryCorners = dec2bin(0:7) - '0';
boxMinimum = plotLimits(:,1)';
boxRange = (plotLimits(:,2) - plotLimits(:,1))';
boxVertices = boxMinimum + binaryCorners .* boxRange;

intersectionPoints = zeros(0,3);
scale = max([norm(w) * norm(boxRange), abs(b), 1]);
tolerance = 1e-10 * scale;

for vertex1 = 1:7
    for vertex2 = vertex1+1:8
        if sum(binaryCorners(vertex1,:) ~= binaryCorners(vertex2,:)) ~= 1
            continue
        end

        point1 = boxVertices(vertex1,:);
        point2 = boxVertices(vertex2,:);
        value1 = dot(w,point1) + b;
        value2 = dot(w,point2) + b;

        if abs(value1) <= tolerance
            intersectionPoints(end+1,:) = point1; %#ok<AGROW>
        end
        if abs(value2) <= tolerance
            intersectionPoints(end+1,:) = point2; %#ok<AGROW>
        end
        if value1 * value2 < 0
            fraction = value1 / (value1 - value2);
            intersectionPoints(end+1,:) = ...
                point1 + fraction * (point2 - point1); %#ok<AGROW>
        end
    end
end

intersectionPoints = uniquetol(intersectionPoints,1e-9,'ByRows',true);
if size(intersectionPoints,1) < 3
    warning('The fitted decision plane does not intersect the plotting box.');
    hPlane = gobjects(1);
    return
end

planeCenter = mean(intersectionPoints,1);
planeBasis = null(w');
projectedPoints = (intersectionPoints - planeCenter) * planeBasis;
pointAngles = atan2(projectedPoints(:,2), projectedPoints(:,1));
[~, pointOrder] = sort(pointAngles);
intersectionPoints = intersectionPoints(pointOrder,:);

hPlane = patch( ...
    'Vertices',intersectionPoints, ...
    'Faces',1:size(intersectionPoints,1), ...
    'FaceColor',[0.5 0.5 0.5], ...
    'FaceAlpha',0.30, ...
    'EdgeColor','none', ...
    'HandleVisibility','off');
end
