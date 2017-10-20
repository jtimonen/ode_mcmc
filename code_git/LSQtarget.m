function [F, J] = LSQtarget(params, Data, Model, alpha, beta)
% Target function for LSQNONLIN optimization
% authors: Jukka Intosalmi, Juho Timonen
% date: 9 Jun 2017

% OUTPUT
% - F: squared values of errors
% - J: jacobian information

Y_data = Data.Y;    y0 = Data.y0';  t = Data.t;

% Parameters to linear scale
params = exp(params);

nF = 2*length(Y_data(:));      % number of objective function components
nDerivatives = length(params); % number of columns in the Jacobian

% Try to solve the system
try
    % Run the CVode solver
    initializeSundials(y0, params, Model);
    [~, ~, y, S] = CVode(t, 'Normal');          
    Y_solved = y';
    CVodeFree;
    if(numel(Y_solved)==0)       
        error('Could not solve ODE system!');
    end         
    
    % The standard deviation depends on the signal
    SIGMA = alpha + beta * abs(Y_solved);
    
    % Set a constant to make the squaring of first term possible and a
    % a lower bound for variance
    c2 = 50;        SIGMA(2*log(SIGMA) + c2 < 0) = exp(-c2/2 + 10^-6);
    
   % Compute the components of likelihood to be squared
    L1 = sqrt(2*log(SIGMA) + c2);       
    L2 = (Y_data - Y_solved) ./ SIGMA;
    F  = [L1(:); L2(:)];                % objective function components
    J = zeros(nF, nDerivatives);        % initialize jacobian matrix
    
    % Derivatives w.r.t. odeParams
    for k = 1:length(params)
        SENS   = squeeze(S(:, k, :))';    
        dL1    = ( beta ./ ( (sqrt(2*log(SIGMA) + c2)) .* SIGMA ) ) .* SENS;
        dL2    = -( 1./SIGMA + beta*(Y_data - Y_solved)./(SIGMA.^2)) .* SENS;
        J(:,k) = [dL1(:); dL2(:)];       
        J(:,k) = J(:,k) * params(k);  % transform to log-derivatives
    end
    
    % Inf or Nan in the solution
    if(sum(isinf(F)) + sum(isnan(F)) > 0)
        F = 10^9*ones(nF, 1);   J = ones(nF, nDerivatives);
    end
    if(sum(sum(isnan(J))) + sum(sum(isinf(J))) > 0)
        F = 10^9*ones(nF, 1);   J = ones(nF, nDerivatives);
    end
catch %err
    % ODE system could not be solved
    F = 10^9*ones(nF, 1);   J = ones(nF, nDerivatives);
    %rethrow(err)
end

%     % Derivatives w.r.t. alpha and beta
%     if(estVar)
%         dL1a = 1./((SIGMA).*sqrt(2 * log(SIGMA) + c2)); 
%         dL1b = dL1a .* Y_solved;
%         dL2a = - (Y_data - Y_solved)./(SIGMA).^2;       
%         dL2b = dL2a .* Y_solved;
%         J(:, end-1) = [dL1a(:); dL2a(:)] * alpha; % transform to log-derivatives
%         J(:, end)   = [dL1b(:); dL2b(:)] * beta;  % transform to log-derivatives
%     end
