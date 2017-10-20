% Compute the unnormalized log-posterior probability (ulpp)
% value for all models in experiment ID under hypothesis that there are M phases.
% - ID should be either 1, 2 or 3 
% - M should be either 1, 2 or 3 (only M = 1, when ID = 1)
% author: Juho Timonen
% date: Oct 20 2017

ID = 2;
M = 3;

% Requires the Sundials Matlab Toolbox
% Tested with Matlab 2016b and sundials-2.4.0
startup_STB()

% Load structs Data and Opt from one of the files below
% - data_opt_sim_1.mat
% - data_opt_sim_2.mat
% - data_opt_sim_3.mat
fname = ['data_opt_sim_', num2str(ID),'.mat'];
load(fname); 
Opt.Bounds

% Get N, number of possible mechanisms
D = Opt.Dynamics;
N = size(D.bas,2)+size(D.act,2)+size(D.synact,2)+size(D.inh,2)+size(D.deg,2);
nGenes = numel(Data.y0);

% Number of free mechanisms
F = length(Opt.freeRows);

% Initialize some variables
INDS = 3538;
%INDS = 1:2^(F*M);
nModels = length(INDS);
Z_default = ones(N, M);
MOD = false(F, M, nModels);
PAR = cell(nModels, 1);
ULPP = zeros(nModels, 1);

for i = INDS
    
    % Z matrix for model i
    z = de2bi(i-1, F*M);        z = reshape(z, F, M);
    Z = Z_default;              Z(Opt.freeRows, :) = z;
    
    % Computation
    [ulpp, par_ml] = est_ulpp(nGenes, Z, Data, Opt);
    
    % Store values
    ULPP(i) = ulpp;             PAR{i} = par_ml;    
    MOD(:, :, i) = logical(z);  fprintf('i = %d, ulpp = %1.2f\n', i, ulpp);
end

% The results are in the variables 'MOD', 'PAR', 'ULPP'