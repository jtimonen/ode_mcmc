% Create data and options to be used in simulated data experiments
% author: Juho Timonen
% date: 9 Jun 2017

% Requires the Sundials Matlab Toolbox
% Tested with Matlab 2016b and sundials-2.4.0

% Set random seed
rng(234125); addpath('src/'); 

% Set the path to sundialsTB here
path_to_STB = '~/csb/odemcmc/';
startup_STB(path_to_STB);

% Noise parameters and gene names
Opt.alpha = 0.0001; Opt.beta = 0.035;   Opt.names = {'A', 'B', 'C'};

% Set allowed parameter bounds
BND.theta = [50, 0.001];    BND.lambda = [3, 0.75];
BND.tau1 = [12, 1];         BND.tau2 = [12, 3];

% Set allowed mechanisms
DYN.bas = [1];
DYN.act = [1, 1, 2, 3; 2, 3, 3, 2];
DYN.inh = [];
DYN.synact = [];
DYN.deg = [1,2,3];

% Set free rows of matrix Z
fr = (length(DYN.bas)+1):(length(DYN.bas)+4);

Opt.Bounds = BND;
Opt.Dynamics = DYN;
Opt.freeRows = fr;

% Z matrix for the data generating model
z0 = [1, 1, 1; ...
      0, 0, 0; ...
      1, 0, 1; ...
      1, 1, 0];
Z0 = ones(4 + 4, size(z0,2));
Z0(fr, :) = z0;
nGenes = length(Opt.names);

% Model parameters
par0 = [1.5, 3, 5, 1.5, 0.5, 2, 3, 1.5, 1, 4, 8];

% Create model struct
Model0 = createModel(nGenes, Z0, Opt.Dynamics);

 fprintf('Model.d = %d, number of set params = %d\n', Model0.d_eff, length(par0));
if(length(par0) ~= Model0.d_eff)
    error('Wrong number of parameters!');
end

% Simulate the data at points t
t = [1,2,3,5,8,12,18,24];
t = repmat(t, 3, 1);
t = t(:);
Data = simulateData(t, Model0, par0, Opt.alpha, Opt.beta);

% Plot the data and real model
theta_y = par0(1:end-4);
theta_x = par0(end-3:end);
ttt = 0.01:0.01:25;
plotModel(nGenes, ttt, Data, Model0, theta_y, theta_x, Opt.names)

% Save the data and options
filename = 'data_and_options.mat';
%save(filename, 'Data', 'Opt', 'Z0', 'par0');



