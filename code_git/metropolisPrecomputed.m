function [i_chain, i_approx, OVL, WWW, OVL_combined, WWW_combined] = ...
    metropolisPrecomputed(MOD, ULPP, max_iter, tol, n_chains, Z0)

% Metropolis sampling with precomputed posterior probability values
% author: Juho Timonen
% date: Oct 5 2017

% Compute full posterior for reference
POST_full = exp(ULPP-max(ULPP));
POST_full = POST_full/sum(POST_full);

N = size(MOD,1);
M = size(MOD,2);
WWW = zeros(N, M, max_iter, n_chains);  % predictions from each chain
OVL = zeros(max_iter, n_chains);        % OVL of full posterior vs. each chain
i_chain = zeros(max_iter, n_chains);    % markov chains of model indices
i_approx = zeros(max_iter, n_chains);   % indices of proposed models for each chain
active = ones(1,n_chains);              % vector defining which chains are running
OVL_combined = zeros(max_iter, 1);      % OVL of full posterior vs. combined approximation
WWW_combined = zeros(N,M,max_iter, 1);  % predictions from combined chains

% Set initial models for the chains
if(nargin > 5)
    m_1 = bi2de(Z0(:)')+1;
    i_chain(1,:) = m_1*ones(1,n_chains);
    i_approx(1,:) = m_1*ones(1,n_chains);
else
    for j = 1:n_chains
        m_1 = randi([1,2^(N*M)]);
        i_chain(1,j) = m_1;
        i_approx(1,j) = m_1;
    end
end

% Start the Metropolis algorithm
for i = 2:max_iter
    for j = find(active)
        % Get current state
        m_old = i_chain(i-1,j);
        Z_old = reshape(de2bi(m_old-1, N*M), N, M);
        
        % Draw a proposal
        Z_prop = flipOneElement(Z_old);
        m_prop = bi2de(Z_prop(:)')+1;
        i_approx(i,j) = m_prop;
        
        % Acceptance probability
        log_old_p = ULPP(m_old);
        log_new_p = ULPP(m_prop);
        p_accept = min(1, exp(log_new_p-log_old_p));
        
        % Accept or reject the proposal
        if rand() < p_accept
            i_chain(i,j) = m_prop;     % accept
        else
            i_chain(i,j) = m_old;      % reject
        end
        POST_approx = getPostApprox(i_approx(1:i,j), POST_full);
        OVL(i,j) = getOvl(POST_full, POST_approx);
        WWW(:, :, i, j) = getWeights(POST_approx, MOD);
        if(OVL(i,j) > tol)
            active(j) = 0;
        end
    end
    
    POST_combined = getCombinedPostApprox(i_approx(1:i,:), POST_full);
    OVL_combined(i) = getOvl(POST_full, POST_combined);
    WWW_combined(:,:,i) = getWeights(POST_combined, MOD);
    fprintf('i = %d, OVL = [ ',i);
    for j = 1:n_chains
        if(active(j))
            fprintf('%f ', OVL(i,j));
        else
            fprintf('HALTED ');
        end
    end
    fprintf('] \n');
    
    i_take = i;
    if(sum(active)==0)
        break
    end
    
end

% Remove tails of zeros
i_chain = i_chain(1:i_take,:);
OVL = OVL(1:i_take,:);
i_approx = i_approx(1:i_take,:);
WWW = WWW(:,:,1:i_take,:);
OVL_combined = OVL_combined(1:i_take);

end

% Helper functions
function q = getPostApprox(i_app, POST_full)
q = POST_full;
explored = unique(i_app);
notexplored = setdiff(1:length(POST_full), explored);
q(notexplored) = 0;
q = q/sum(q);
end

function q = getCombinedPostApprox(i_approx, POST_full)
q = POST_full;
explored = unique(i_approx(:));
notexplored = setdiff(1:length(POST_full), explored);
q(notexplored) = 0;
q = q/sum(q);
end

function ovl = getOvl(p,q)
if(sum(isnan(p))+sum(isnan(q)) > 0)
    ovl = 0;
else
    ovl = sum(min(p, q));
end
end

function W = getWeights(q, MOD)
W = zeros(size(MOD,1), size(MOD,2));
for i = 1:size(MOD,3)
    W = W + MOD(:,:,i)*q(i);
end
end


