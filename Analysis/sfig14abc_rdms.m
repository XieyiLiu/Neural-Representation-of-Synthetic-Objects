% Supplementary Fig. 14a-c: VTC and comparison RDMs.
% Average subject-level similarities and display neural, behavioral, and model RDMs.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'sfig14abc_rdms.mat'));

%% VTC RDM
figure;
imagesc(1-(mean(rb_pv_allsub,3)));title('VTC');
colormap(flipud(parula));colorbar;axis square;

%% Neural and behavioral models
figure;set(gcf,'Position',[100 100 1300 330]);
subplot(1,4,1);imagesc(1-(frephys100));title('Macaque IT');colormap(flipud(parula));colorbar;axis square;
subplot(1,4,2);imagesc(1-(online_psy));title('Odd-one-out task');colormap(flipud(parula));colorbar;axis square;
subplot(1,4,3);imagesc(1-(mean(bh,3)));title('Image categorization task');colormap(flipud(parula));colorbar;axis square;
subplot(1,4,4);imagesc(1-(picSm2));title('Object space');colormap(flipud(parula));colorbar;axis square;

%% Visual and semantic models
figure;set(gcf,'Position',[100 100 1300 330]);
subplot(1,4,1);imagesc(1-(alexnet_corr));title('AlexNet');colormap(flipud(parula));colorbar;axis square;
subplot(1,4,2);imagesc(1-(mean(sm_8fmrivec_mpnet,3)));title('Semantic (MPNet)');colormap(flipud(parula));colorbar;axis square;
subplot(1,4,3);imagesc(1-(mean(sm_8fmrivec_bert,3)));title('Semantic (BERT)');colormap(flipud(parula));colorbar;axis square;
subplot(1,4,4);imagesc(1-(mean(sm_8fmrivec_word2vec,3)));title('Semantic (fastText)');colormap(flipud(parula));colorbar;axis square;
