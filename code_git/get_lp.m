function lp = get_lp(row, X)
% Latent function for a single ROW of Z given the parametric form X (sym)
% author: Juho Timonen
% date: 9 Jun 2017

M = length(row);

if(M==1)
    if(length(X)~=1)
        error('Lengths of ROW and X do not match!');
    end
    lp = 1;
elseif(M==2)
    if(length(X)~=2)
        error('Lengths of ROW and X do not match!');
    end
    if(    sum(row==[1,1]) == 2)
        lp = 1;
    elseif(sum(row==[1,0]) == 2)
        lp = X(1);
    elseif(sum(row==[0,1]) == 2)
        lp = X(2);
    else
        error('Cannot create the latent process for a zero row!');
    end
elseif(M==3)
     if(length(X)~=3)
        error('Lengths of ROW and X do not match!');
    end
    if(    sum(row==[1,1,1]) == 3)
        lp = 1;
    elseif(sum(row==[1,1,0]) == 3)
        lp = X(1)+X(2);
    elseif(sum(row==[1,0,1]) == 3)
        lp = X(1)+X(3);
    elseif(sum(row==[0,1,1]) == 3)
        lp = X(2)+X(3);
    elseif(sum(row==[1,0,0]) == 3)
        lp = X(1);
    elseif(sum(row==[0,1,0]) == 3)
        lp = X(2);
    elseif(sum(row==[0,0,1]) == 3)
        lp = X(3);
    else
        error('Invalid ROW in latent process creation!');
    end
else
    error('Too long ROW!');
end
