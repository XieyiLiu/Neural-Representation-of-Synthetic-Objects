% Shared figure helper: Two-sided median-difference permutations with add-one p-values and null percentiles.
function [T_obs, p_perm, ci_perm] = local_permtest_medianDiff(x, y, nPerm)

    x = x(:); y = y(:);
    n1 = numel(x); n2 = numel(y);
    N  = n1 + n2;

    T_obs = median(x) - median(y);

    xy = [x; y];
    T_perm = zeros(nPerm,1);

    for i = 1:nPerm
        idx = randperm(N);
        x_p = xy(idx(1:n1));
        y_p = xy(idx(n1+1:end));
        T_perm(i) = median(x_p) - median(y_p);
    end

    p_perm = (sum(abs(T_perm) >= abs(T_obs)) + 1) / (nPerm + 1);

    ci_perm = prctile(T_perm, [2.5 97.5]);
end
