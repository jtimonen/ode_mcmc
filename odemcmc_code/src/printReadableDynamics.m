function [] = printReadableDynamics(Opt)
% Print allowed mechanisms in a human-readable form
% author: Juho Timonen
% date: 9 Jun 2017

Dynamics = Opt.Dynamics;
names = Opt.names;
freeRows = Opt.freeRows;

bas = Dynamics.bas;         n1 = size(bas, 2);
act = Dynamics.act;         n2 = size(act, 2);
synact = Dynamics.synact;   n3 = size(synact, 2);
inh = Dynamics.inh;         n4 = size(inh, 2);
deg = Dynamics.deg;         n5 = size(deg, 2);

mlen = 0;
S = length(names);

fprintf('\n');
for i = 1:S
    if(length(names{i}) > mlen)
        mlen  = length(names{i});
    end
end

for i = 1:S
   d = mlen - length(names{i});
   names{i} = [names{i}, repmat(' ', 1, d)];
end

counter = 0;
for i = 1:n1
    counter = counter + 1;
    p = 0;
    if(sum(freeRows==counter)>0)
        fprintf('    | ');
    else
        fprintf('*** | ');
    end
    if(counter < 10)
        fprintf(' ')
    end
    fprintf(['', num2str(counter), '']);
    fprintf(' |')
    while(p < 3*mlen + 10 - (mlen + 3))
        fprintf(' ');
        p = p + 1;
    end

    fprintf([' –> ', names{bas(i)}]);
    fprintf(' \n');
end

for i = 1:n2
    counter = counter + 1;
    p = 0;
    if(sum(freeRows==counter)>0)
        fprintf('    | ');
    else
        fprintf('*** | ');
    end
    if(counter < 10)
        fprintf(' ')
    end
    fprintf(['', num2str(counter), '']);
    fprintf(' |')
    while(p < 3*mlen + 10 - (2*mlen + 3))
        fprintf(' ');
        p = p + 1;
    end
    fprintf([names{act(1, i)},' –> ', names{act(2, i)}, '']);
    fprintf(' \n');
end

for i = 1:n3
    counter = counter + 1;
    p = 0;
    if(sum(freeRows==counter)>0)
        fprintf('    | ');
    else
        fprintf('*** | ');
    end
    if(counter < 10)
        fprintf(' ')
    end
    fprintf(['', num2str(counter), '']);
    fprintf(' |')
    while(p < 3*mlen + 10 - (3*mlen + 6))
        fprintf(' ');
        p = p + 1;
    end
    fprintf([names{synact(1, i)}, ' + ', names{synact(2, i)} ' –> ', names{synact(3, i)}, '']);
    fprintf(' \n');
    
end

for i = 1:n4
    counter = counter + 1;
    p = 0;
    if(sum(freeRows==counter)>0)
        fprintf('    | ');
    else
        fprintf('*** | ');
    end
    if(counter < 10)
        fprintf(' ')
    end
    fprintf(['', num2str(counter), '']);
    fprintf(' |')
    while(p < 3*mlen + 10 - (2*mlen + 3))
        fprintf(' ');
        p = p + 1;
    end
    fprintf([names{inh(1, i)},' –| ', names{inh(2, i)}, '']);
    fprintf(' \n');
    
end

for i = 1:n5
    counter = counter + 1;
    p = 0;
    if(sum(freeRows==counter)>0)
        fprintf('    | ');
    else
        fprintf('*** | ');
    end
    if(counter < 10)
        fprintf(' ')
    end
    fprintf(['', num2str(counter), '']);
    fprintf(' |')
    while(p < 3*mlen + 10 - (2*mlen + 3))
        fprintf(' ');
        p = p + 1;
    end
    fprintf([names{deg(i)}, ' –> ']);
    p = 0;
    while(p < mlen + 1)
        fprintf(' ');
        p = p + 1;
    end
    fprintf(' \n');
    
end

fprintf('\n');

end

