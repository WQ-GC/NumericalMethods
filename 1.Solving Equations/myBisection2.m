function [x, nsteps, vector_a, vector_b] = myBisection2(f, a, b, tol, nmax)

if nargin == 4
    nmax = 100;
end

vector_a(1) = a;    %v(i) is the ith element in the vector v.
vector_b(1) = b;

for i = 1 : nmax
    c = (vector_a(i) + vector_b(i)) / 2;
    
    if (vector_b(i) - vector_a(i)) <= tol || f(c) == 0;
        break;
    end
    
    if f(c) * f(vector_a(i)) > 0
        vector_a(i + 1) = c;
        vector_b(i + 1) = vector_b(i);
    else
        vector_a(i+1) = vector_a(i);
        vector_b(i+1) = c;
    end
end

x = (vector_a(i) + vector_b(i)) / 2;
nsteps = i - 1;
end
