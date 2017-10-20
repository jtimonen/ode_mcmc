function [] = main_Th17(n_iter, filename, M)
% Main function for the th17 inference
% author: Juho Timonen
% date: June 13 2017
% - M = hypothesis about the number of phases

% Requires the Sundials Matlab Toolbox
% Tested with Matlab 2016b and sundials-2.4.0
startup_STB()
rng('shuffle')
fprintf('Results will be saved to %s \n', filename);

% Load variables Dat, Opt
load('data_opt_th17.mat');

% Print optimization bounds and all possible dynamics
Opt.Bounds
printReadableDynamics(Opt);

% Initial model
Z0 = Opt.initial_Z;
Z0 = Z0(:, 1:M);

% Saving frequency in seconds
saveFreq = 30*60;

% Start Metropolis algorithm
metropolis(Dat, Opt, Z0, n_iter, filename, saveFreq);

