function [mchain, SSIZE, OVL, WWW] = mainSim(exp_id, M)

% Run the inference for any of the three simulated experiments
% with pre-computed ulpp values
% author: Juho Timonen
% date: Jun 12 2017

% Input:
% - exp_id = either 1, 2 or 3
% -      M = hypothesis about number of latent states (not applicable when
%          exp_id == 1)

% Output:
% -   mchain = obtained Markov chain
% - SSIZE(i) = size of the posterior approximation support at iteration i
% -   OVL(i) = overlapping coefficient between the posterior approximation
%            at iteration i and the real model posterior
% -   WWW(i) = inferred model structure matrix weights at iteration i

% All possible uses:
%   run_inference(1)
%   run_inference(2, 1)
%   run_inference(2, 2)
%   run_inference(2, 3)
%   run_inference(3, 1)
%   run_inference(3, 2)
%   run_inference(3, 3)

addpath src/

% Set random seed
rng(841031)
filename = ['results/simulated/exp', num2str(exp_id)];
if(nargin > 1)
    filename = [filename, '_', num2str(M)];
end

% Set initial model
if(exp_id == 1)
    Z0 = zeros(12, 1);
else
    Z0 = zeros(4, M);
end

load(filename);                 % load variables MOD, PAR and ULPP
max_iter = 10^5;                % max iterations for sampling
tol = 0.99;                     % stopping condition for OVL

% Run sampling
[mchain, SSIZE, OVL, WWW] = metropolisPrecomputed(Z0, MOD, ULPP, max_iter, tol);

% Plot OVL trace
plot(SSIZE, OVL); hold on;      ylim([0,1]);
xlabel('Number of models');     ylabel('OVL');

% Plot some results if exp_id == 1
if(exp_id == 1)
    POST = exp(ULPP-max(ULPP));
    POST = POST/sum(POST);
    W_real = zeros(size(MOD,1), size(MOD,2));
    for i = 1:size(MOD,3)
        W_real = W_real + MOD(:, :, i)*POST(i);
    end
    
    i1 = find(SSIZE == 30, 1);      i2 = find(SSIZE == 100, 1);
    W_approx1 = WWW(:, :, i1);      W_approx2 = WWW(:, :, i2);
    
    figure;
    BARS = [W_real(:), W_approx1(:), W_approx2(:)];
    bar(BARS);
    
    labels = cell(12,1);
    labels{1} = 'A –> B';
    labels{2} = 'A –> C';
    labels{3} = 'B –> A';
    labels{4} = 'B –> C';
    labels{5} = 'C –> A';
    labels{6} = 'C –> B';
    labels{7} = 'A –| B';
    labels{8} = 'A –| C';
    labels{9} = 'B –| A';
    labels{10} = 'B –| C';
    labels{11} = 'C –| A';
    labels{12} = 'C –| B';
    
    set(gca,'XTickLabel', labels);
    set(gca,'XTickLabelRotation', 90);
    legend('W_{real}', 'W_{30}', 'W_{100}')
    ylabel('Link weight');  axis tight;
end


end
