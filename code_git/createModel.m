function Model = createModel(n, Z, Dynamics)
% CREATEMODEL Create a LEM model
% authors: Jukka Intosalmi, Juho Timonen
% date: 9 Jun 2017

if(sum(Z(:))==0)
    error('Z must have at least one non-zero value!');
end

ncol = size(Z, 2);
if(ncol > 3)
    error('Cannot handle Z with more than 3 columns!');
end

% Remove consecutive identical columns
D = Z(:, 1:(end-1)) - Z(:, 2:end);    D = sum(abs(D));        
ident = not(logical(D));              Z(:, ident) = [];
M = size(Z, 2);                       nonZeroRows = logical(sum(Z,2));      

% This is the number of parameters that should be used when computing BIC
n_params = sum(nonZeroRows) + (ncol-1)*2;

% This is the number of parameters that there actually are needed in the model
d_eff = sum(nonZeroRows) + (M-1)*2;

bas = Dynamics.bas;         nBas = size(bas, 2); 
act = Dynamics.act;         nAct = size(act, 2); 
synact = Dynamics.synact;   nSynAct = size(synact, 2); 
inh = Dynamics.inh;         nInh = size(inh, 2); 
deg = Dynamics.deg;         nDeg = size(deg, 2); 

% Create symbolic state and parameter variables
Y = sym('y', [n, 1]);       P = sym('p', [d_eff, 1]);       

% Create latent process
syms t; 
if(M==1)
    X = 1+t*0;
elseif(M==2)
    L = sym('lambda');             T = sym('tau');
    x2 = sigmf(t, [L(1), T(1)]);   x1 = 1 - x2;
    X = [x1; x2];
elseif(M==3);
    L = sym('lambda', [2, 1]);     T = sym('tau', [2, 1]);
    x1 = 1 - sigmf(t, [L(1), T(1)]);
    x3 = sigmf(t, [L(2), T(1)+T(2)]);
    x2 = 1 - x1 - x3;
    X = [x1; x2; x3];
end

% Create symbolic F (right-hand side of the ODE)
F = 0 * sym('foo', [n, 1]);  nCount = 0; pCount = 0;

% Add basal activations to ODE
for i = 1:nBas
    ind = bas(i);
    nCount = nCount + 1;
    row = Z(nCount, :);
    if sum(row) > 0
        pCount = pCount + 1;
        lp = get_lp(row, X);
        F(ind) = F(ind) + lp*P(pCount);
    end
end

% Add activations to ODE
for i = 1:nAct
    i_activator = act(1,i);
    i_target = act(2, i);
    nCount = nCount + 1;
    row = Z(nCount, :);
    if sum(row) > 0
        pCount = pCount + 1;
        lp = get_lp(row, X);
        F(i_target) = F(i_target) + lp*P(pCount)*Y(i_activator);
    end
end


% Add synergistic activations to ODE
for i = 1:nSynAct
    i_activator1 = synact(1,i);
    i_activator2 = synact(2,i);
    i_target = synact(3, i);
    nCount = nCount + 1;
    row = Z(nCount, :);
    if sum(row) > 0
        pCount = pCount + 1;
        lp = get_lp(row, X);
        F(i_target) = F(i_target) + lp*P(pCount)*Y(i_activator1)*Y(i_activator2);
    end
end

% Add inhibitions to ODE
for i = 1:nInh
    i_inhibitor = inh(1,i);
    i_target = inh(2, i);
    nCount = nCount + 1;
    row = Z(nCount, :);
    if sum(row > 0)
        pCount = pCount + 1;
        lp = get_lp(row, X);
        F(i_target) = F(i_target) - lp*P(pCount)*Y(i_inhibitor)*Y(i_target);
    end
end

% Add degradations to ODE
for i = 1:nDeg
    ind = deg(i);
    nCount = nCount + 1;
    row = Z(nCount, :);
    if sum(row) > 0
        pCount = pCount + 1;
        lp = get_lp(row, X);
        F(ind) = F(ind) - lp*P(pCount)*Y(ind);
    end
end

% Replace lambda and tau with p-notation
if(M==3)
    F = subs(F, 'lambda1', ['p', num2str(pCount+1)]);
    F = subs(F, 'lambda2', ['p', num2str(pCount+2)]);
    F = subs(F, 'tau1', ['p', num2str(pCount+3)]);
    F = subs(F, 'tau2', ['p', num2str(pCount+4)]);
elseif(M==2)
    F = subs(F, 'lambda', ['p', num2str(pCount+1)]);
    F = subs(F, 'tau', ['p', num2str(pCount+2)]);
end

% Create the needed function handles
[rhsfn, rhsSfn, djacfn, R] = constructCvodesInput(F, Y, P);

% Create output struct
Model.lfn       = matlabFunction(X);
Model.M         = M;
Model.n         = n;
Model.Z         = Z;
Model.rhsfn     = rhsfn;
Model.rhsSfn    = rhsSfn;
Model.djacfn    = djacfn;
Model.R         = R;
Model.n_params  = n_params;
Model.d_eff     = d_eff;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rhsfn, rhsSfn, djacfn, R] = constructCvodesInput(F, Y, P)
% Create needed function handles for the CVODES solver

% dimensions
n=length(Y); d=length(P);

S = sym('s', [n, d]); % sensitivity matrix
J = jacobian(F, Y);
R = jacobian(F, P);

% Evaluate right-hand side function based on F
temp_funstr = func2str(matlabFunction(F)); index = find(temp_funstr=='[');
temp_funstr = temp_funstr(index:end);
for i = n:-1:1
    temp_funstr = regexprep(temp_funstr,['y',int2str(i)],['y(',int2str(i),')']);
end
for i = d:-1:1
    temp_funstr = regexprep(temp_funstr,['p',int2str(i)],['tht(',int2str(i),')']);
end

eval(['rhsfn = @(t,y,tht)deal(', temp_funstr, ',0,[]);'])

% Compute U
U = J*S + R;

% Evaluate right-hand side sensitivity based on U
temp_funstr = func2str(matlabFunction(U));  index = find(temp_funstr=='r');
temp_funstr = temp_funstr(index:end);
for i = n:-1:1
    temp_funstr = regexprep(temp_funstr,['y',int2str(i)],['y(',int2str(i),')']);
end
count = n*d + n;
for i = d:-1:1
    for j = n:-1:1 
        temp_funstr = regexprep(temp_funstr,['s',int2str(j),'_',int2str(i)],['S(',int2str(j),',',int2str(i),')']);
        count = count - 1;
    end
end
for i = d:-1:1
    temp_funstr = regexprep(temp_funstr,['p',int2str(i)],['tht(',int2str(i),')']);
end
eval(['rhsSfn = @(t,y,yd,S,tht)deal(',temp_funstr,',0,[]);']);

% Evaluate R
temp_funstr = func2str(matlabFunction(R));  index = find(temp_funstr=='r');
temp_funstr = temp_funstr(index:end);
for i = n:-1:1
    temp_funstr = regexprep(temp_funstr,['y',int2str(i)],['y(',int2str(i),')']);
end
for i = d:-1:1
    temp_funstr = regexprep(temp_funstr,['p',int2str(i)],['tht(',int2str(i),')']);
end
eval(['R = @(t,y,tht)',temp_funstr,';'])

% Evaluate Jacobian of right-hand side
temp_funstr = func2str(matlabFunction(J));  index = find(temp_funstr=='r');
temp_funstr = temp_funstr(index:end);
for i = n:-1:1
    temp_funstr = regexprep(temp_funstr,['y',int2str(i)],['y(',int2str(i),')']);
end
for i = d:-1:1
    temp_funstr = regexprep(temp_funstr,['p',int2str(i)],['tht(',int2str(i),')']);
end
eval(['djacfn = @(t,y,fy,tht)deal(',temp_funstr,',0,[]);'])

end



