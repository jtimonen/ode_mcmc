function [] = mainTh17(n_iter, filename, M)

% Main function for the th17 inference
% author: Juho Timonen
% date: June 13 2017

% Requires the Sundials Matlab Toolbox
% Tested with Matlab 2016b and sundials-2.4.0

fprintf('File to save: %s \n', filename);

% Set the path to sundialsTB here
path_to_STB = '~/csb/odemcmc';
startup_STB(path_to_STB);
addpath('src');

% Load variables Data, Opt
load('datasets/th17_data_opt.mat');

% Set random seed
rng('shuffle')

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

