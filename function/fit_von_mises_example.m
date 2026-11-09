% Shared figure helper: Fit one/two-peak models with bounded multistart least squares.
function [p1,p2] = fit_von_mises_example(x,y,vm1,vm2,lb1,ub1,lb2,ub2,opts,nStart2)

    A0 = max(y) - min(y);
    [~,i0] = max(y);
    mu0 = x(i0);
    b0 = min(y);

    p01 = [A0, mu0, 1, b0];
    try
        p1 = lsqcurvefit(vm1, p01, x, y, lb1, ub1, opts);
    catch
        p1 = p01;
    end

    %% Two-peak multistart fit
    bestSSE = Inf;
    for s = 1:nStart2
        mu1_0 = mod(mu0 + (rand*2-1)*pi, 2*pi);
        mu2_0 = mod(mu0 + (rand*2-1)*pi, 2*pi);
        p02 = [A0, mu1_0, 1, A0/2, mu2_0, 1, b0];
        try
            p2_tmp = lsqcurvefit(vm2, p02, x, y, lb2, ub2, opts);
            sse = sum((y - vm2(p2_tmp, x)).^2);
            if sse < bestSSE
                bestSSE = sse; p2 = p2_tmp;
            end
        catch
        end
    end

    if exist('p2','var') && p2(1) < p2(4)
        p2 = [p2(4) p2(5) p2(6)  p2(1) p2(2) p2(3)  p2(7)];
    end

end
