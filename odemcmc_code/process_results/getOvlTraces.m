function [OVL12, OVL34] = getOvlTraces(M)

% Check input
if((M==1)||(M==2))
    n_chains = 2;
elseif(M==3)
    n_chains = 4;
else
    error('M must be 1, 2, or 3!');
end

% Download results to cell structures
MODS = cell(n_chains,1);
ULPPS = cell(n_chains,1);
for j = 1:n_chains
    resultfile = ['ciof', num2str(M),'_chain',num2str(j)];
    load(['../results/th17_5days/', resultfile]);
    MODS{j} = MOD;
    ULPPS{j} = ULPP;
end

% OVL trace between chains 1 and 2
[~, ULPP, I1, I2] = modelSetUnion(MODS{1}, ULPPS{1}, MODS{2}, ULPPS{2});

len1 = length(I1);      len2 = length(I2);
L = min(len1, len2);    OVL12 = zeros(L, 1);
for i = 1:L
    q1 = createApproximation(ULPP, I1(1:i));
    q2 = createApproximation(ULPP, I2(1:i));
    OVL12(i) = sum(min(q1,q2));
end

if(M==3)
    % OVL trace between chains 3 and 4
    [~, ULPP, I3, I4] = modelSetUnion(MODS{3}, ULPPS{3}, MODS{4}, ULPPS{4});
    len3 = length(I3);      len4 = length(I4);
    L = min(len3, len4);    OVL34 = zeros(L, 1);
    for i = 1:L
        q3 = createApproximation(ULPP, I3(1:i));
        q4 = createApproximation(ULPP, I4(1:i));
        OVL34(i) = sum(min(q3,q4));
    end
end


end
