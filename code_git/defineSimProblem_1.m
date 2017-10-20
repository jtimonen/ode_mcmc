% Create problem where data is simulated from a one-phase model
% author: Juho Timonen
% date: 19 Oct 2017

% Requires the Sundials Matlab Toolbox
% Tested with Matlab 2016b and sundials-2.4.0
startup_STB();
rng('shuffle'); 
 
% Noise parameters and gene names
Opt.alpha = 0.0001; Opt.beta = 0.035;   Opt.names = {'A', 'B', 'C'};

% Set allowed parameter bounds
BND.theta = [30, 0.001];    BND.lambda = [3, 0.75];
BND.tau1 = [12, 1];         BND.tau2 = [12, 3];

% Set allowed mechanisms
DYN.bas = [1,2,3];
DYN.act = [1,1,2,2,3,3; 2,3,1,3,1,2];
DYN.inh = [1,1,2,2,3,3; 2,3,1,3,1,2];
DYN.synact = [];
DYN.deg = [1,2,3];

% Set free rows of matrix Z
fr = (3+1):(3+12); fr = fr';

Opt.Bounds = BND;
Opt.Dynamics = DYN;
Opt.freeRows = fr;

% Z matrix for the data generating model
z0 = [1,0,0,1,0,0, 0,0,0,0,1,1]';
Z0 = ones(18,1);
Z0(fr, :) = z0;
nGenes = length(Opt.names);

% Model parameters
par0 = [1,1,1, 5,2.5,0.15,1, 0.5,0.5,0.8];

% Create model struct
Model0 = createModel(nGenes, Z0, Opt.Dynamics);

fprintf('Model.d = %d, number of given params = %d\n', Model0.d_eff, length(par0));
if(length(par0) ~= Model0.d_eff)
    error('Wrong number of parameters!');
end

% Simulate the data at points t
t = [0.25, 0.5, 1, 2, 3, 4, 5, 6, 7];
t = repmat(t, 3, 1);
t = t(:);
Data = simulateData(t, Model0, par0, Opt.alpha, Opt.beta);

% Plot the data and real model
M = size(Z0,2);
theta_y = par0(1:end-2*(M-1));
theta_x = par0(end-2*(M-1)+1:end);
ttt = 0.01:0.01:8;
plotModel(nGenes, ttt, Data, Model0, theta_y, theta_x, Opt.names)

% The results are in data_opt_3.mat