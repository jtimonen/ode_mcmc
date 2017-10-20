function [ulpp, par_ml, OPT_info] = est_ulpp(n, Z, Data, Opt)
% Compute a BIC estimate for model marginal log-likelihood
% authors: Jukka Intosalmi, Juho Timonen
% date: 9 Jun 2017

Model  = createModel(n, Z, Opt.Dynamics);
alpha = Opt.alpha;
beta = Opt.beta;
    
% Build parameter bounds
[UB, LB] = buildOptimBounds(Model.d_eff, Model.M, Opt.Bounds);

% Optimize maximum likelihood parameters
[par_ml, OPT_info] = ms_optim(Model, Data, UB, LB, alpha, beta);
    
% Compute log likelihood with ml params
log_max_lh = logLikelihood(par_ml, Model, Data, alpha, beta);

% Compute the estimate for ulpp using BIC
n_meas = numel(Data.Y);
d = Model.n_params;
ulpp = log_max_lh - d/2 * log(n_meas);

end
