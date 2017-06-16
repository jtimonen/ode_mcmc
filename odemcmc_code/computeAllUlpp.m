function [MOD, PAR, ULPP] = computeAllUlpp(ID, M)

% Compute the unnormalized log-posterior probability (ulpp)
% value for all models in experiment ID under hypothesis that there are M phases.
% - ID should be either 1, 2 or 3 
% - M should be either 1, 2 or 3 (only M = 1, when ID = 2 or 3)
% author: Juho Timonen
% date: Jun 16 2017

if((ID==1) && (M~=1))
    error('Only M = 1 is possible for ID = 1!');
end

% Requires the Sundials Matlab Toolbox
% Tested with Matlab 2016b and sundials-2.4.0

% Load structs Data and Opt, print the optimization bounds
fname = ['exp', num2str(ID), '_data_opt.mat'];
load(['data_and_options/', fname]); Opt.Bounds

% Get N, number of possible mechanisms
D = Opt.Dynamics;
N = size(D.bas,2)+size(D.act,2)+size(D.synact,2)+size(D.inh,2)+size(D.deg,2);
nGenes = numel(Data.y0);

% Number of free mechanisms
F = length(Opt.freeRows);

% Number of all possible models under the hypothesis
nModels = 2^(F*M);

% Get filename for saving
I = strfind(fname, '_');
str = fname(1:I(1));
file_to_save = [str, num2str(M),'.mat'];
fprintf('Results will be saved to %s \n', file_to_save);

% Initialize some variables
Z_default = ones(N, M);
MOD = false(F, M, nModels);
PAR = cell(nModels, 1);
ULPP = zeros(nModels, 1);

% Compute ulpp value for each model
for i = 1:nModels
    
    % Z matrix for model i
    z = de2bi(i-1, F*M);        z = reshape(z, F, M);
    Z = Z_default;              Z(Opt.freeRows, :) = z;
    
    % Computation
    [ulpp, par_ml] = est_ulpp(nGenes, Z, Data, Opt);
    
    % Store values
    ULPP(i) = ulpp;             PAR{i} = par_ml;    
    MOD(:, :, i) = logical(z);  fprintf('i = %d, ulpp = %1.2f\n', i, ulpp);
end

% Save the results
save(file_to_save, 'MOD', 'PAR', 'ULPP');

end
