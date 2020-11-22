function[Sx] = WQ_CubicSpline(in_x_vec, in_y_vec, in_colour)
    clc
    if(nargin <=1)
        [in_x_vec, in_y_vec] = HandleInputs(nargin);
    end

    %Perform Cubic Spline
    %See slides 21 for formula
    %lower_delta_i = x(i+1) - x(i) 
    %upper_delta_i = y(i+1) - y(i)
    %Compute lower_delta_i and upper_delta_i
    
    [ptCounts,colCounts] = size(in_x_vec);
    
    for(i = 1: (ptCounts-1))
%         in_x_vec(i+1)
%         in_x_vec(i)
        l_delta(i) = in_x_vec(i+1) - in_x_vec(i);
        u_delta(i) = in_y_vec(i+1) - in_y_vec(i);
    end
    
    %Formulate Cubic Matrix
    LHS_M = zeros(ptCounts, ptCounts);
    LHS_M(1,1) = 1;
    LHS_M(ptCounts, ptCounts) = 1;
    
    counter = 1;
    for(rowCount = 2: ptCounts-1)
        LHS_M(rowCount, rowCount-1) = l_delta(counter);
        
        %Diagonal
        LHS_M(rowCount, rowCount) = 2*l_delta(counter) + 2*l_delta(counter + 1);
        
        LHS_M(rowCount, rowCount+1) = l_delta(counter + 1);
        
        counter = counter + 1;
    end

    %ci is a col vector of n rows
    c_vec = zeros(ptCounts,1);
    
    %RHS is also a col vector of n rows
    RHS_s = zeros(ptCounts,1);
    for(rowCount = 2: ptCounts-1)
        RHS_s(rowCount) = 3 * ( (u_delta(rowCount) / l_delta(rowCount)) - ((u_delta(rowCount-1) / l_delta(rowCount-1))));
    end
    
    %Solving for Cubic Spline Coefficients (bi, ci and di)    
    %bi and di are from 1 to (n-1) ***
    b_vec = zeros(ptCounts-1,1);
    d_vec = zeros(ptCounts-1,1);
    
    %Solve for ci
    %USE JACOBI Iterative METHOD    
    %LHS_M is diagonally dominant - Checked by WQ_Jacobi()
    MAX_ITER = 1000;        %set to 1000 iterations
    c0_vec = zeros(ptCounts,1);    %initial vector
    c_tol = 1e-5;
    [c_vec, getIterations] = WQ_Jacobi(LHS_M, RHS_s, MAX_ITER, c0_vec, c_tol);
    c_last_vec = c_vec(:,end)

    %Double Check with normal method c_vec = LHS_M\RHS_s
    
    %Solve for di
    for(i  = 1:ptCounts-1)
        d_vec(i) = (c_last_vec(i+1) - c_last_vec(i)) / (3 * l_delta(i));
    end
        
    %Solve for bi
    for(i  = 1:ptCounts-1)
        b_vec(i) = (u_delta(i) / l_delta(i)) - (l_delta(i) * (2 * c_last_vec(i) + c_last_vec(i + 1)) / 3);
    end
    
    %Construct Cubic Splines
    %Si(x) = yi + bi(x-xi) + ci(x-xi)^2 + di(x-xi)^3 for[xi to x(i+1)]
    Sx = ConstructCubicSplines(d_vec, c_last_vec, b_vec, in_x_vec, in_y_vec, ptCounts);
%         Test_Plot(Sx, in_x_vec, in_y_vec, ptCounts);
%         hold on    

    for(i = 1: ptCounts-1)
        Sx(i);
    end

    WQ_PlotAll(in_x_vec, in_y_vec, Sx, ptCounts-1, in_colour)
end

function[out_Si]  = ConstructCubicSplines(dvec, cvec, bvec, xvec, yvec, counts)
    format short
    syms x
    for(i = 1: counts-1)
        out_Si(i) = (dvec(i) * (x - xvec(i))^3) ...
                          + (cvec(i) * (x - xvec(i))^2) ...
                          + (bvec(i) * (x - xvec(i))) ...
                          +  yvec(i);         
    end          
end

function[out_x_vec, out_y_vec]  = HandleInputs(in_arg)
    if (in_arg == 0)
        %out_x_vec = GetRandomX();        
       out_x_vec = [0;0.101369;0.350684;0.600000;0.849315;1.098630;1.347945;1.597260;1.865753];
    end
     
    if (in_arg <= 1)        
        %out_y_vec = GetRandomY();
        out_y_vec = [1.7623; 1.7749;  1.7432; 1.7426; 1.7567; 1.7851; 1.8331; 1.8701; 1.9176];              
    end
end

function[out_x_vec] = GetRandomX()
    out_x_vec =  randi(1,1);
    for i = 2:10
        out_x_vec(i) = out_x_vec(i-1) + (1 * randi([1 10],1,1));
    end
end

function[out_y_vec] = GetRandomY()
    out_y_vec =  randi(1,1);

    for i = 2:10
        out_y_vec(i) = out_y_vec(i-1) + (1 * randi([1 10],1,1)); 
    end
end