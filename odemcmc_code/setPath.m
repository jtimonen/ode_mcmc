function [] = setPath(path_to_STB)
% Set the path to Sundials ODE solver functions and other functions needed
% in the inference

% Author: Juho Timonen
% Date: Jun 16 2017

% The file startup_STB.m should be in the sundialsTB directory
addpath(fullfile(path_to_STB), sundialsTB)

% Add the sundials toolbox functions to path
startup_STB(path_to_STB);

% Add other functions to path
addpath('src');

end

