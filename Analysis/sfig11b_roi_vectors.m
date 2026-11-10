% Supplementary Fig. 11b
% Compute ROI vectors and standardize lengths against shuffled responses.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig11b_roi_vectors.mat'));

rng(random_state);
pol_observed=zeros(2,3,4,8);pol_null=zeros(1000,2,3,4,8);
for ss=1:8
 for hh=1:4
  betaall=beta_by_subject(:,:,hh,ss);
  [theta,r]=cart2pol(predimg_axis1.'*betaall,predimg_axis2.'*betaall);
  pol_observed(:,:,hh,ss)=[theta;r/1000];
  for rep=1:1000
   for condition=1:3
    b=betaall(randperm(100),condition);
    [theta,r]=cart2pol(predimg_axis1.'*b,predimg_axis2.'*b);
    pol_null(rep,:,condition,hh,ss)=[theta,r/1000];
   end
  end
 end
end
pol_standardized=pol_observed;
for ss=1:8
 for hh=1:4
  for condition=1:3
   null=pol_null(:,2,condition,hh,ss);
   pol_standardized(2,condition,hh,ss)=(pol_observed(2,condition,hh,ss)-mean(null))/std(null);
  end
 end
end
figure;set(gcf,'Position',[100 100 1200 600],'Renderer','painters');
panel_numbers = cellfun(@(id) sscanf(id,'S%d'), subject_ids);
assert(isequal(sort(panel_numbers(:))',1:8), 'Expected S1 through S8.');
for ss = 1:length(subjall)
    subj = subjall{ss};
    pax = subplot(2,4,panel_numbers(ss), polaraxes);
    hold(pax, 'on');
    title(pax, subject_ids{ss}, 'FontName','Tahoma','FontSize',10,'FontWeight','bold');
    thetaticks(pax, 0:90:360);
    set(pax, 'FontName','Ariel','FontSize',10,'FontWeight','bold')
for hh=1:numel(ROIall)
pol_pv=pol_standardized(:,1,hh,ss)';pol_task1=pol_standardized(:,2,hh,ss)';pol_task2=pol_standardized(:,3,hh,ss)';

        roi_color = {[0 0 1],[0 0.75 1],[1 0 0],[0.18 0.31 0.31]};

        line_color = roi_color{hh};

        polarplot(repmat(pol_task1(1),10), linspace(0,pol_task1(2),10), ...
            'LineWidth',1.3,'Color',line_color); hold on;
        polarplot(repmat(pol_task2(1),10), linspace(0,pol_task2(2),10), ...
            'LineWidth',1.3,'Color',line_color,'LineStyle','--'); hold on;
        polarplot(repmat(pol_pv(1),10), linspace(0,pol_pv(2),10), ...
            'LineWidth',1.3,'Color',line_color,'LineStyle','-.'); hold on;

    end

    rmax = pax.RLim(2);
    pax.RTick = rmax;
    pax.RTickLabel = {num2str(round(rmax,2))};
    pax.RColor = [0.5 0.5 0.5];
    pax.ThetaColor = [0.5 0.5 0.5];
    pax.LineWidth = 0.8;

end
