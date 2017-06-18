function [ output_args ] = getStructureAndHypothesisTest( input_args )
%GETSTRUCTUREANDHYPOTHESISTEST Summary of this function goes here
%   Detailed explanation goes here

for M = 1:3
% Download results to cell structures
MODS = cell(n_chains,1);
ULPPS = cell(n_chains,1);
for j = 1:n_chains
    resultfile = ['ciof', num2str(M),'_chain',num2str(j)];
    load(['../results/th17_5days/', resultfile]);
    MODS{j} = MOD;
    ULPPS{j} = ULPP;
end

end

