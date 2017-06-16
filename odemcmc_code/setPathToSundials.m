function [] = setPathToSundials(filepath)
% Set the path to Sundials ODE solver as a global variable so that
% it does not have to be defined each time you run code that employs
% Sundials

% Author: Juho Timonen
% Date: Jun 16 2017

global path_to_STB
path_to_STB = filepath;


end

