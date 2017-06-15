function [par_ml, INFO] = ms_optim(Model, Data, UB, LB, alpha, beta)
% MS_OPTIM Optimize maximum likelihood parameters using a multistart schedule
% authors: Jukka Intosalmi, Juho Timonen
% date: 9 Jun 2017

% Optimize in log scale
ub = log(UB);   lb = log(LB);   

% Optimization options
OPToptions = optimoptions('lsqnonlin','Jacobian','on','Display','off');

d_eff = length(ub); n_starts = 10*d_eff;

PARAMS = zeros(n_starts, d_eff);  
VALUES = zeros(n_starts, 1);
FLAGS = nan(n_starts, 1);
LHC = lhsdesign(n_starts, d_eff);
    
% Run multistarts in parallel
parfor i = 1:n_starts
    p0 = lb + (ub -lb) .* LHC(i,:);         % initial point
    target = @(p)LSQtarget(p, Data, Model, alpha, beta);

    % Run least squares optimization
    [p_tmp, resnorm, ~, flag] = lsqnonlin(target, p0, lb, ub, OPToptions);
    PARAMS(i,:) = p_tmp;
    if(numel(resnorm) > 0)
        VALUES(i) = resnorm; 
    else
        VALUES(i) = 10^9;
    end
    FLAGS(i) = flag;
    
end

[VALUES, order] = sort(VALUES);
PARAMS = exp(PARAMS(order, :));
FLAGS = FLAGS(order);

INFO.values = VALUES;
INFO.params = PARAMS;
INFO.flags = FLAGS;

par_ml = PARAMS(1, :);  % max likelihood params


end

