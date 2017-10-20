% Main script for demonstrating the inference when information from
% multiple chains is combined
% - Uses precomputed model probabilities
% author: Juho Timonen
% date: Oct 20 2017
exp_id = 1;
M = 1;
n_chains = 3;
rng(123456)

filename = ['precomputed_values/res', num2str(exp_id)];
filename = [filename, '_', num2str(M)];

load(filename);                 % load variables MOD, PAR and ULPP
max_iter = 10^5;                % max iterations for sampling
tol = 0.99;                     % stopping condition for OVL

%% Run sampling
[i_chain, i_approx, OVL, WWW, OVL_combined, WWW_combined] = ...
    metropolisPrecomputed(MOD, ULPP, max_iter, tol, n_chains);

%% Process results
figure;
col = [228,26,28;
       55,126,184;
       77,175,74;
       152,78,163;
       255,127,0;
       255,255,51;
       166,86,40;
       247,129,191];
   
col = col/255;

% Results from single chains
runlengths = zeros(n_chains,1);
for j = 1:n_chains   
    inz = i_approx(:,j) > 0;
    i_app = i_approx(inz,j);
    i_ch = i_chain(inz,j);
    L = sum(inz);
    runlengths(j) = L;
    trace = zeros(L,3);
    for i = 1:L
        n_evaluated = length(unique(i_app(1:i)));
        ovl = OVL(i,j);
        n_accepted = length(unique(i_ch(1:i)));
        trace(i,:) = [n_evaluated, ovl, n_accepted];
    end
    plot(trace(:,1),trace(:,2),'LineWidth',1,'Color', col(j,:)); hold on;
    arate = sum(i_ch(1:L-1)-i_ch(2:L)~=0)/(L-1);
    fprintf('Results for chain %d \n',j);
    fprintf('   acceptance rate: %1.4f\n',  arate);
    fprintf('   iterations run: %d\n',   L);
    fprintf('   models evaluated: %d\n', trace(end,1));
    fprintf('   models accepted: %d\n\n', trace(end,3));
end
xlabel('Computational cost');   ylabel('OVL');  ylim([0,1]);

% Combined chain
len = min(runlengths);
trace_combined = zeros(len,2);
for i = 1:len
    umod = unique(i_approx(1:i,:));
    cost = length(umod(:))/n_chains;
    trace_combined(i,:) = [cost,OVL_combined(i)];
end
plot(trace_combined(:,1),trace_combined(:,2),'k','LineWidth',1);

% Create legend
leg_labels = cell(n_chains+1,1);
for j = 1:n_chains
    leg_labels{j} = ['chain ', num2str(j)];
end
leg_labels{end} = 'combined ';
legend(leg_labels);
axis tight;