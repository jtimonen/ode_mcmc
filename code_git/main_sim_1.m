% Main script for running the inference in Experiment 1
% where data is from a one-phase model
% - Uses precomputed model probabilities
% author: Juho Timonen
% date: Oct 20 2017

exp_id = 1;
M = 1;
n_chains = 1;

rng(123)
filename = ['precomputed_values/res', num2str(exp_id)];
filename = [filename, '_', num2str(M)];

% Set initial model
Z0 = zeros(12, 1);

load(filename);                 % load variables MOD, PAR and ULPP
max_iter = 10^5;                % max iterations for sampling
tol = 0.99;                     % stopping condition for OVL

%% Run sampling
[i_chain, i_approx, OVL, WWW] = ...
    metropolisPrecomputed(MOD, ULPP, max_iter, tol, n_chains, Z0);

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

% Results
subplot(2,1,1);
L = length(i_approx);
trace = zeros(L,3);
for i = 1:L
    n_evaluated = length(unique(i_approx(1:i)));
    ovl = OVL(i);
    n_accepted = length(unique(i_chain(1:i)));
    trace(i,:) = [n_evaluated, ovl, n_accepted];
end
plot(trace(:,1),trace(:,2),'k','LineWidth',1); hold on;
arate = sum(i_chain(1:L-1)-i_chain(2:L)~=0)/(L-1);
fprintf('Results \n');
fprintf('   acceptance rate: %1.4f\n',  arate);
fprintf('   iterations run: %d\n',   L);
fprintf('   models evaluated: %d\n', trace(end,1));
fprintf('   models accepted: %d\n\n', trace(end,3));

xlabel('Number of models');
ylabel('OVL');
axis tight;
ylim([0,1]);

i1 = find(trace(:,1)==80);   n1 = trace(i1(1),1);
i2 = find(trace(:,1)==100);  n2 = trace(i2(1),1);
plot(n1,OVL(i1(1)), '.', 'MarkerSize', 15, 'Color', col(1,:));
plot(n2,OVL(i2(1)), '.', 'MarkerSize', 15, 'Color', col(2,:));

% Plot predictions

% Compute predictions from the full posterior for reference
P_full = exp(ULPP-max(ULPP));
P_full = P_full/sum(P_full);
W_full = zeros(size(MOD,1), size(MOD,2));
for i = 1:size(MOD,3)
    W_full = W_full + MOD(:,:,i)*P_full(i);
end

subplot(2,1,2);

W1 = WWW(:,:,i1(1));
W2 = WWW(:,:,i2(1));
W_plot = [W1,W2,W_full];
b = bar(W_plot); hold on;
for j = 1:length(b)-1
    b(j).FaceColor = col(j,:);
    b(j).EdgeColor = 'none';
end
b(end).FaceColor = 0.25*ones(1,3);
b(end).EdgeColor = 'none';
axis tight; ylabel('Link weight');
legend(['W_{',num2str(n1),'}'],['W_{',num2str(n2),'}'],'W_{full}');

mech_labels = cell(12,1);
mech_labels{1} =  'A --> B';
mech_labels{2} =  'A --> C';
mech_labels{3} =  'B --> A';
mech_labels{4} =  'B --> C';
mech_labels{5} =  'C --> A';
mech_labels{6} =  'C --> B';
mech_labels{7} =  'A --| B';
mech_labels{8} =  'A --| C';
mech_labels{9} =  'B --| A';
mech_labels{10} = 'B --| C';
mech_labels{11} = 'C --| A';
mech_labels{12} = 'C --| B';
ax = gca;
ax.XTickLabel = mech_labels;
ax.XTickLabelRotation = 90;