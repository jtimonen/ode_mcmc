function [UB, LB] = buildOptimBounds(d_eff, M, B)
% Create bound vectors for optimization
% author: Juho Timonen
% date: 9 Jun 2017

thetaBounds = repmat(B.theta', 1, d_eff - 2*(M-1));
lambdaBounds = repmat(B.lambda', 1, M-1);

% Handle all possible cases of what tau bounds are needed
% depending on how many different latent states there are
if M == 3
    tauBounds = [B.tau1', B.tau2'];
elseif M == 2
    tauBounds = [B.tau2(1)+B.tau1(1); B.tau1(2)];
else
    tauBounds = [[];[]];
end

b = [thetaBounds, lambdaBounds, tauBounds]; 
UB = b(1, :);
LB = b(2, :);

end

