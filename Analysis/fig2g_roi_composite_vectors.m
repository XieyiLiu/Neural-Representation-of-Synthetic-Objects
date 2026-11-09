% Fig. 2g: ROI composite vectors
% Plot ROI composite vectors for real and synthetic objects.
clear
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig2g_roi_composite_vectors.mat'));

figure;
set(gcf,'Position',[100,100,1600,800]);
cc = {[0 0 1],[0 0.75 1],[1 0 0],[0.18 0.31 0.31]};
polall = {'pol_realobj','pol_pv'};
condition_titles = {'Real objects','Synthetic objects'};
for sub = 1:2
    subplot(1,2,sub)
    eval(['pp = ' polall{sub} ';'])
    for q = 1:length(ROIall)
        polarplot(repmat(pp(:,1,q),10),linspace(0,pp(:,2,q),10),'LineWidth',3,'Color',cc{q}); hold on;
    end
    title(condition_titles{sub},'FontName','Ariel','FontSize',10,'FontWeight','bold','Interpreter','none')
    set(gca,'FontName','Ariel','FontSize',10,'FontWeight','bold')
    thetaticks(0:90:360)
    rlim([0 15])
end

nROI = size(pol_pv, 3);
cosSim = nan(1, nROI);

for k = 1:nROI
    th1 = pol_pv(1,1,k);      r1 = pol_pv(1,2,k);
    th2 = pol_realobj(1,1,k); r2 = pol_realobj(1,2,k);

    v1 = [r1*cos(th1), r1*sin(th1)];
    v2 = [r2*cos(th2), r2*sin(th2)];

    denom = norm(v1) * norm(v2);
    if denom == 0
        cosSim(k) = NaN;
    else
        cosSim(k) = dot(v1, v2) / denom;
    end
end

disp(cosSim);
