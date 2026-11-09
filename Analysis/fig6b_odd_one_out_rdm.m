% Fig. 6b: odd-one-out RDM
% Split-half Pearson reliability and two-sided image-label permutations with add-one correction.
package_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(package_dir, 'function'));
load(fullfile(package_dir, 'Source_Data', 'fig6b_odd_one_out_rdm.mat'));

figure;
imagesc(1-(online_psy));
colormap(flipud(parula));axis square;
cb = colorbar; cb.Label.String = 'Dissimilarity';

%% Split-half reliability and label permutations

rng(reliability_settings.rng_seed,'twister');
nPics = reliability_settings.n_images;
nSample = reliability_settings.n_resamples;
nTrials = size(odd_trials,1);
nPerGroup = nTrials/2;
assert(mod(nTrials,2)==0,'An even number of trials is required.');

lower_mask = tril(true(nPics),-1);
nPairs = nnz(lower_mask);
pair_lookup = zeros(nPics);
pair_lookup(lower_mask) = 1:nPairs;
pair_lookup = pair_lookup + pair_lookup';
pair_positions = [1 2; 1 3; 2 3];
trial_pair_ids = zeros(nTrials,3);
unchosen_pair_ids = zeros(nTrials,1);
for pair_index = 1:3
    pic_a = odd_trials(:,pair_positions(pair_index,1));
    pic_b = odd_trials(:,pair_positions(pair_index,2));
    ids = pair_lookup(sub2ind([nPics nPics],pic_a,pic_b));
    trial_pair_ids(:,pair_index) = ids;
    unchosen = pic_a~=odd_trials(:,4) & pic_b~=odd_trials(:,4);
    unchosen_pair_ids(unchosen) = ids(unchosen);
end
assert(all(trial_pair_ids(:)>0) && all(unchosen_pair_ids>0));
all_counts = accumarray(trial_pair_ids(:),1,[nPairs 1]);
all_unchosen = accumarray(unchosen_pair_ids,1,[nPairs 1]);

rs = zeros(1,nSample);
ps = zeros(1,nSample);
rs_null = zeros(1,nSample);
fprintf('\n=== Odd-one-out split-half reliability: %d splits and label permutations ===\n',nSample);
for sp = 1:nSample
    groupOne = randsample(1:nTrials,nPerGroup);
    counts_one = accumarray(reshape(trial_pair_ids(groupOne,:),[],1),1,[nPairs 1]);
    unchosen_one = accumarray(unchosen_pair_ids(groupOne),1,[nPairs 1]);

    v1 = unchosen_one ./ counts_one;
    v2 = (all_unchosen-unchosen_one) ./ (all_counts-counts_one);
    [rs(sp),ps(sp)] = corr(v1,v2,'rows','complete');

    sm2 = zeros(nPics);
    sm2(lower_mask) = v2;
    sm2 = sm2 + sm2';
    perm = randperm(nPics);
    sm2p = sm2(perm,perm);
    rs_null(sp) = corr(v1,sm2p(lower_mask),'rows','complete');
end

mixAllRs = rs;
z_split = atanh(mixAllRs(:));
z_null = atanh(rs_null(:));
z_obs = median(z_split);
median_split_half_r = median(mixAllRs);
p_perm_z = (sum(abs(z_null)>=abs(z_obs))+1)/(numel(z_null)+1);
ci_z = prctile(z_split,[2.5 97.5]);
ci_r = tanh(ci_z);

split_half_stats = struct('median_r',median_split_half_r,'z_obs',z_obs, ...
    'p_perm',p_perm_z,'n_resamples',nSample,'rng_seed',reliability_settings.rng_seed, ...
    'n_exceedances',sum(abs(z_null)>=abs(z_obs)), ...
    'n_trials',nTrials,'n_subjects',reliability_settings.n_subjects_after_qc, ...
    'tail','two-sided','p_correction','add-one','resampling_range_r',ci_r, ...
    'r_split',mixAllRs,'r_null',rs_null);
fprintf('Median split-half r = %.8f (%.2f)\n',median_split_half_r,median_split_half_r);
fprintf('Two-sided label-permutation test: p = %.12g, nPerm = %d, add-one correction\n',p_perm_z,nSample);
fprintf('95%% split-half resampling range: [%.6f, %.6f]; seed = %d\n',ci_r(1),ci_r(2),reliability_settings.rng_seed);
