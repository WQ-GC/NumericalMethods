function [x, nsteps] = myBisection(a, b, tol, nmax)

    if nargin == 3
        nmax = 100;
    end

    if myF(a) * myF(b) > 0

    end

    for i = 1 : nmax
        c = (a + b) / 2;

        if (b - a) <= tol || myF(c) == 0;
            break;
        end

        if myF(c) * myF(a) > 0
            a = c;
        else
            b = c;
        end
    end

    x = (a+b) / 2;
    nsteps = i - 1;
end

function [f_v] = myF(x)
    f_v = x^2 - 3; 
end



