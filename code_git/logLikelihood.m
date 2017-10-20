function log_lh = logLikelihood(theta_xy, Model, Data, alpha, beta)
% Compute log-likelihood of a model given the data
% authors: Jukka Intosalmi, Juho Timonen
% date: 9 Jun 2017

% Initialize the solver
initializeSundials(Data.y0', theta_xy, Model);

% Run solver
[~, ~, y,  ~] = CVode(Data.t,'Normal');
CVodeFree;

if(numel(y)>0)
    % The response corresponds to the mean of normal distribution
    MU = y';
    SIGMA = alpha + beta * abs(MU);
    
    % Compute the log-likelihood
    Y_data = Data.Y;
    log_lh = sum( log( 1./sqrt(2*pi*SIGMA(:).^2) ) - ((Y_data(:) - MU(:)).^2) ./ (2*SIGMA(:).^2) );
else
    % Ode system could not be solved
    log_lh = -10^9;
    %error('Could not solve system!\n');
end

if(isnan(log_lh))
    log_lh = -10^9;
    %error('Value of log likelihood is not a number!\n');
end

%fprintf('Log likelihood is %f\n', log_lh); 
end