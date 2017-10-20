function Z_new = flipOneElement(Z_old, freeRows)
% Flip one element of a binary matrix (drawn from a uniform distribution)
% authors: Juho Timonen
% date: 9 Jun 2017

[N, M] = size(Z_old);

if(nargin == 1)
    freeRows = 1:N;
end

nFree = length(freeRows);

c = randi([1, M]);
r = freeRows(randi([1, nFree]));
Z_new = Z_old;
Z_new(r, c) = mod(Z_new(r,c) + 1, 2);

end

