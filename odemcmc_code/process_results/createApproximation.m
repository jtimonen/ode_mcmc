
function q = createApproximation(ULPP, IND)

nq = length(ULPP);
q = -Inf*ones(nq, 1);
q(IND) = ULPP(IND);
q = exp(q - max(q));
q = q/sum(q);


end
