function [] = initializeSundials(y0, odeParams, Model)

% Perform required steps to initialize the CVODES solver
% authors: Jukka Intosalmi, Juho Timonen
% date: 9 Jun 2017

% Set options according to parameters and Jacobian 
opt = CVodeSetOptions('UserData', odeParams, 'JacobianFn', Model.djacfn, 'ErrorMessages', false);

% Initialize CVode with these options, RHS and initial value y0
%   - choose multistep-method ('BDF' or 'Adams')
%   - choose nonlinear solver type ('Functional' or 'Newton')
CVodeInit(Model.rhsfn, 'BDF', 'Newton', 0, y0 , opt);

% Set initial sensitivities
yS0 = Model.R(0, y0 , odeParams);

% Define simultaneous calculation of sensitivities
FSAoptions = CVodeSensSetOptions('method', 'Simultaneous', 'ErrControl', true);

% Initialize sensitivity calucation with the function rhsSfn
CVodeSensInit(Model.d_eff, Model.rhsSfn, yS0, FSAoptions);