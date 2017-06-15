function [mchain, MOD, ULPP, PAR] ...
    = metropolis(Data, Opt, Z0, max_iter, file2save, saveFreq)
% Metropolis algorithm for ODE/LEM models
% author: Juho Timonen
% date: June 13 2017

% Configuration matrix rows that correspond to non-fixed mechanisms
freeRows = Opt.freeRows;

% Number of genes
n_genes = length(Data.y0);

% Initial model
[ulpp1, par1] = est_ulpp(n_genes, Z0, Data, Opt);
MOD = Z0(freeRows, :);
ULPP(1) = ulpp1;
PAR{1} = par1;
mchain   = 1;

% Start the algorithm
tic;
for i = 2:max_iter
    
    % Get current configuration Z (only free rows)
    index_old = mchain(i-1);
    Z = MOD(:,:,index_old);
    ulpp_old = ULPP(index_old);
    
    % 1) DRAW 1 MODEL FROM NEIGHBORHOOD OF Z
    Y = flipOneElement(Z);
    index_prop = checkModelMemory(Y, MOD);
    
    % 2) ESTIMATE UNNORMALIZED LOG-POSTERIOR FOR THE DRAWN MODEL
    if(index_prop==0)
        % Proposal is a new model
        Z_prop = Z0;          Z_prop(freeRows, :) = Y;
        [ulpp_prop, par]    = est_ulpp(n_genes, Z_prop, Data, Opt);
        index_prop          = length(ULPP) + 1;
        ULPP(index_prop)    = ulpp_prop;
        PAR{index_prop}     = par;
        MOD(:,:,index_prop) = Y;
    else
        % Proposal already in memory
        ulpp_prop = ULPP(index_prop);
    end
    
    % 3) CALCULATE ACCEPTANCE PROBABILITY AND POSSIBLY MAKE TRANSITION
    p_accept = min(1, exp(ulpp_prop - ulpp_old));
    if rand() < p_accept
        mchain(i) = index_prop;     % accept
    else
        mchain(i) = index_old;      % reject
    end
    
    % Print information about the progress
    fprintf('i = %d, ulpp = %1.2f, proposal = %1.2f, models = %d \n', ...
        i, ULPP(mchain(i)), ulpp_prop, length(ULPP));
    
    % Save current state if enough time has passed
    timer = toc;
    if(timer > saveFreq || i == max_iter)
        tic;
        fprintf('Time: %1.2f min, Saving...\n', timer/60);
        try
            save(file2save, 'MOD', 'ULPP', 'PAR', 'mchain');
            fprintf('   Done!\n');
        catch
            fprintf('   error with saving!\n');
        end
    end
    
end

end

% A helper function for cheking if a model is already cached
function imem = checkModelMemory(Z, MEM_m)
    [n, m, r] = size(MEM_m);    
    H = reshape(MEM_m, n*m, r);
    H = H';
    z = Z(:);
    [~,imem] = ismember(z', H, 'rows');
end



