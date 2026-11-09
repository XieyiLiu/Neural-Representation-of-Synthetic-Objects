% Supplementary Fig. 3b-c: FDR q-value and F-statistic distributions.
% Benjamini-Hochberg FDR correction and q-value/F-statistic histograms.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig3bc_bimodality_distributions.mat'));

%% FDR correction
valid=~isnan(pval);
qval=nan(size(pval));
qval(valid)=mafdr(pval(valid),'BHFDR',true);
alpha=0.05;
sig=qval<alpha;
fprintf('Vertices tested: %d / %d\n',sum(valid),nVertex);
fprintf('Significant 2-peak (FDR q<%.3f): %d (%.2f%% of tested)\n',alpha,sum(sig),100*mean(sig(valid)));

%% q-value and F-statistic distributions
fig=figure('Color','w','Position',[100 100 1000 400]);
layout=tiledlayout(fig,1,2,'TileSpacing','loose','Padding','loose');
bar_color=[100 169 211]/255;

ax_q=nexttile(layout,1);
h_q=histogram(ax_q,qval(valid),30,'FaceColor',bar_color,'FaceAlpha',1,'EdgeColor','none');
hold(ax_q,'on');
xlim(ax_q,[-0.05 1.05]);
ylim(ax_q,[0 max(5000,ceil(max(h_q.Values)/1000)*1000)]);
xticks(ax_q,0:0.2:1);
yticks(ax_q,0:1000:ax_q.YLim(2));
threshold_line=xline(ax_q,alpha,'--','Color',[0.75 0.75 0.75],'LineWidth',1.4);
text(ax_q,alpha+0.02,ax_q.YLim(2)*0.97,'q(FDR) = 0.05', ...
    'FontName','Arial','FontSize',10,'VerticalAlignment','top','Color','k');
xlabel(ax_q,'q(FDR)');ylabel(ax_q,'Number of vertices');
set(ax_q,'FontName','Arial','FontSize',11,'TickDir','out','Box','off');
text(ax_q,-0.20,1.06,'b','Units','normalized','FontName','Arial','FontSize',13,'FontWeight','bold','Clipping','off');

ax_f=nexttile(layout,2);
h_f=histogram(ax_f,Fval(valid),30,'FaceColor',bar_color,'FaceAlpha',1,'EdgeColor','none');
xlim(ax_f,[-1 max(27,max(h_f.BinEdges))]);
ylim(ax_f,[0 max(30000,ceil(max(h_f.Values)/5000)*5000)]);
xticks(ax_f,0:5:ax_f.XLim(2));
yticks(ax_f,0:5000:ax_f.YLim(2));
ax_f.YAxis.Exponent=4;
xlabel(ax_f,'F statistic');ylabel(ax_f,'Number of vertices');
set(ax_f,'FontName','Arial','FontSize',11,'TickDir','out','Box','off');
text(ax_f,-0.20,1.06,'c','Units','normalized','FontName','Arial','FontSize',13,'FontWeight','bold','Clipping','off');
