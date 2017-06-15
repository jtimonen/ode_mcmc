function [mchain, SSIZE, OVL, WWW] = ...
    metropolisPrecomputed(Z0, MOD, ULPP, max_iter, tol)

% Metropolis sampling with precomputed posterior probability values
% author: Juho Timonen
% date: June 12 2017

% Get the real posterior distribution
POST = exp(ULPP-max(ULPP));
POST = POST/sum(POST);
        
% Initialize the chain
[N, M] = size(Z0);
mchain = zeros(max_iter, 1);
OVL = zeros(max_iter, 1);
SSIZE = zeros(max_iter, 1);
WWW = zeros(N, M, max_iter);
mchain(1) = bi2de(Z0(:)')+1;


% Start the Metropolis algorithm
for i = 2:max_iter
    
    % Get current state
    m_old = mchain(i-1);
    Z_old = reshape(de2bi(m_old-1, N*M), N, M);
    
    % Draw a proposal
    Z_prop = flipOneElement(Z_old);
    m_prop = bi2de(Z_prop(:)')+1;
    
    % Acceptance probability
    post_old = POST(m_old);
    post_prop = POST(m_prop);
    p_accept = min(1, post_prop/post_old);
    
    % Accept or reject the proposal
    if rand() < p_accept
        mchain(i) = m_prop;     % accept
    else
        mchain(i) = m_old;      % reject
    end
    
    [POST_approx, ssize] = getPostApprox(mchain(1:i), POST);
    ovl = getOvl(POST, POST_approx);
    OVL(i) = ovl;
    SSIZE(i) = ssize;
    WWW(:, :, i) = getWeights(POST_approx, MOD);
    if(ovl > tol)
        break;
    end
    fprintf('i = %d, ulpp = %1.2f overlap = %f \n', i, ULPP(mchain(i)), ovl);
end

inds = (mchain>0);
mchain = mchain(inds);
OVL = OVL(inds);
SSIZE = SSIZE(inds);
WWW = WWW(:, :, inds);
end

function [q, num_models] = getPostApprox(mchain, POST)
    q = POST;
    explored = unique(mchain);
    notexplored = setdiff(1:length(POST), explored);
    q(notexplored) = 0;
    q = q/sum(q);
    num_models = length(explored);
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
        W = W + MOD(:, :, i)*q(i);
    end   
end


