function [x, nsteps, table] = myBisection3(f, a, b, tol, nmax)
% Write intermediate steps into a table 
% How to export the result table into excel? Check it
if nargin == 4
    nmax = 100;
end

% table is an array data type
table = {'i' 'a' 'b' 'f(a)' 'f(b)' 'c' 'f(c)' 'Update' 'new b-a'};

for i = 1 : nmax
    c = (a + b) / 2;
    
    if (b - a) <= tol || f(c) == 0;
        break;
    end
    
    table(i + 1, :) = {i a b f(a) f(b) c f(c) 'a=c' nan};
    
    if f(c) * f(a) > 0
        a = c;
    else
        b = c;
        table(i+1, 8) = {'b=c'};
    end
    table(i+1, 9) = {b-a};
end

x = (a + b)/2;
nsteps = i - 1;
end

