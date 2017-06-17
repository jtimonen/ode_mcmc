function [MOD, ULPP, inds1, inds2] = modelSetUnion(MOD1, ULPP1, MOD2, ULPP2)
% Combine two sets of models that might interlap

% Author: Juho Timonen
% Date: Jun 19 2017

MOD = MOD1;             ULPP = ULPP1;
K1 = length(ULPP1);     K2 = length(ULPP2);
n_same = 0;             inds1 = 1:K1;

for i = 1:K2
    M2 = MOD2(:, :, i);
    addthis = 1;
    index_in_MOD1 = 0;
    for j = 1:K1
        M1 = MOD(:, :, j);
        DIF = abs(M1-M2);
        if(sum(DIF(:))==0)
            % Model M2 is already in MOD
            addthis = 0;
            n_same = n_same + 1;
            index_in_MOD1 = j;
            break;
        end
    end
    if(addthis)
        MOD(:, :, end+1) = M2;
        ULPP(end+1) = ULPP2(i);
        inds2(i) = length(ULPP);
    else
        % If both chains optimized the same model
        % get the better ulpp value
        u1 = ULPP1(index_in_MOD1);
        u2 = ULPP2(i);
        ULPP(index_in_MOD1) = max(u1,u2);
        inds2(i) = index_in_MOD1;
    end
    
    % Print progress
    if(mod(i, 100) == 0)
        fprintf('progress: %1.1f %% \n', i/K2*100);
    end
end

fprintf('There were %d models in set 1.\n', K1);
fprintf('There were %d models in set 2.\n', K2);
fprintf('There were %d common models.\n', n_same);

inds1 = 1:K1;
end

