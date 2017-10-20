function Data = simulateData(t, Model, odeParams, alpha, beta)

% Simulate data
Data.y0 = 0.01*ones(1, Model.n);
Data.t = t;
nMeas = length(t);

% CVODES initialization with the known ode parameters
initializeSundials(Data.y0', odeParams, Model);

% Solve the model when parameters are known 
[~, ~, Y, ~] = CVode(Data.t, 'Normal'); 
CVodeFree;
Y = Y';

% Add normally distributed measurement noise
Y_noisy = zeros(length(t), Model.n);

for i = 1:nMeas
    row = Y(i, :);
    sigma = alpha + beta*row;
    Y_noisy(i, :)= row + sigma.*randn(1, Model.n);
end

Data.Y = Y_noisy;

