function [] = startup_STB(stb_path)
% STARTUP_STB  path/environment setup script for sundialsTB

% Radu Serban <radu@llnl.gov>
% Copyright (c) 2007, The Regents of the University of California.
% $Revision: 4074 $Date: 2007/08/21 17:43:48 $

if nargin == 0
  stb_path = '~/Documents/CSB/odemcmc/';
  stb = fullfile(stb_path,'sundialsTB');
else
  stb = fullfile(stb_path,'sundialsTB');
end
  

if ~exist(stb, 'dir')
  warning('SUNDIALS Toolbox not found!!'); 
  return
else
  fprintf('SUNDIALS Toolbox found at %s!\n', stb);
end

% Add top-level directory to path

addpath(stb);

% Add sundialsTB components to path

q = fullfile(stb,'cvodes');
if exist(q, 'dir')
  addpath(q);
  q = fullfile(stb,'cvodes','cvm');
  addpath(q);
  q = fullfile(stb,'cvodes','function_types');
  addpath(q);
end

q = fullfile(stb,'idas');
if exist(q, 'dir')
  addpath(q);
  q = fullfile(stb,'idas','idm');
  addpath(q);
  q = fullfile(stb,'idas','function_types');
  addpath(q);
end

q = fullfile(stb,'kinsol');
if exist(q, 'dir')
  addpath(q);
  q = fullfile(stb,'kinsol','kim');
  addpath(q);
  q = fullfile(stb,'kinsol','function_types');
  addpath(q);
end

q = fullfile(stb,'nvector');
if exist(q, 'dir')
  addpath(q);
end

q = fullfile(stb,'putils');
if exist(q, 'dir')
  addpath(q);
end


