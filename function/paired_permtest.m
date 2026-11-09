% Shared figure helper: Two-sided sign-flip test of paired mean differences; return correlation separately.
function [r_obs, p_perm] = paired_permtest(x, y, nPerm)

    valid = ~(isnan(x) | isnan(y));
    x = x(valid);
    y = y(valid);

    r_obs = corr(x, y);
    d_obs = mean(x - y);

    d_perm = zeros(nPerm,1);
    n = numel(x);

    for i = 1:nPerm
        sign_flip = (rand(n,1) > 0.5)*2 - 1;
        d_perm(i) = mean((x - y) .* sign_flip);
    end

    p_perm = (sum(abs(d_perm) >= abs(d_obs)) + 1) / (nPerm + 1);
end
