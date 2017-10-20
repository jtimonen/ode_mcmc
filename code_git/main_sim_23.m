% Main script for running the inference in Experiments 2 and 3
% where data is from a two- or three-phase model
% - Uses precomputed model probabilities
% author: Juho Timonen
% date: Oct 20 2017

ID = [2,3];
rng(135)                        % random seed
max_iter = 4*10^3;              % max iterations for sampling
tol = 0.99;                     % stopping condition for OVL
col = [140,140,140;             % colours for plotting
    10,10,10;
    245,50,50];
col = col/255;

% Loop through experiments
for exp_id = ID
    subplot(1,2,exp_id-1)
    AR = zeros(1,3);
    IRUN = zeros(1,3);
    MEVAL = zeros(1,3);
    MACC = zeros(1,3);
    
    % Loop through hypotheses about the number of phases
    for M = 1:3
        n_chains = 1;
        filename = ['precomputed_values/res', num2str(exp_id)];
        filename = [filename, '_', num2str(M)];
        Z0 = zeros(4, M);               % set initial model
        load(filename);                 % load variables MOD, PAR and ULPP
        
        % Run sampling
        [i_chain, i_approx, OVL, WWW] = ...
            metropolisPrecomputed(MOD, ULPP, max_iter, tol, n_chains, Z0);
        
        % Results
        L = length(i_approx);
        trace = zeros(L,3);
        for i = 1:L
            n_evaluated = length(unique(i_approx(1:i)));
            ovl = OVL(i);
            n_accepted = length(unique(i_chain(1:i)));
            trace(i,:) = [n_evaluated, ovl, n_accepted];
        end
        
        % Plot OVL against the full model posterior as a function of evaluated
        % models
        plot(trace(:,1),trace(:,2),'Color', col(M,:),'LineWidth',1); hold on;
        arate = sum(i_chain(1:L-1)-i_chain(2:L)~=0)/(L-1);
        fprintf('Results \n');
        AR(M) =  arate;
        IRUN(M) = L;
        MEVAL(M) = trace(end,1);
        MACC(M) = trace(end,3);
        
    end
    
    legend('M = 1','M = 2','M = 3','Location','SouthEast');
    xlabel('Number of models');
    ylabel('OVL');
    axis tight;
    ylim([0,1]);
    title(['Data from a model with ', num2str(exp_id), ' phases']);
    
    % Show acceptance rate and other numbers about the runs
    display(AR)
    display([IRUN;MEVAL;MACC])
end