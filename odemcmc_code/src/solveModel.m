function [t, Y] = solveModel(ttt, theta_xy, Model, y0)
% Solve a single ODE model
% authors: Jukka Intosalmi, Juho Timonen
% date: 9 Jun 2017

initializeSundials(y0, theta_xy, Model);

% Run solver
[~, t, y, ~] = CVode(ttt,'Normal'); 
Y = y';

% Free memory
CVodeFree;
   