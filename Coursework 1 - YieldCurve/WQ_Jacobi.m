%Ax = b
%For Jacobi, A must be diagonally dominant
function [x_vec_Full, numIter] = WQ_Jacobi(A, b, NMAX, x0_vec, tol)
    clc
	%format rat
    format short
    %format longe

    if nargin == 0
        A = [11             0.1              0.2;
                -0.2            22               2.1;
                3               3                   333]; 

        %Non-Diagonally Dominant
%         A = [1111       1              1;
%                 2222        -2            2;
%                 3               3              3333] 
    end
    
    if nargin <= 1
        b = [10;
                 5;                 
                 4];
    end
    
    if nargin <= 2
        NMAX = 100;
    end
    
    if nargin <= 3
        x0_vec = [100;
                           100;
                           100];
    end
    
    if nargin <= 4
        tol = 1e-4;
    end

    if(WQ_CheckDiagDom(A) ~= true)  
        disp("NOT Diagonally Dominant, Jacobi Not applicable")        
        numIter = -1
    else
        disp("Diagonally Dominant") 
        
        %x_new = M_Jacobian * x_prev   +    D_Inv *b
        %Another form      x_new = D_Inv * (b - (L + U) x_rev)
        %Extract Jacobi D, L, U Matrix
        A;
        D_Jacobi = diag(diag(A));
        D_Jacobi_Inv = inv(D_Jacobi);
        A_NoDiag = (A - D_Jacobi);        
        L_Jacobi = tril(A_NoDiag);
        U_Jacobi = triu(A_NoDiag);
        LnU_Jacobi = L_Jacobi + U_Jacobi;
        %Only calculated once
        M_Jacobi = -1 * D_Jacobi_Inv * LnU_Jacobi;       %Watch out minus sign
    
        %Iterate next set of x_vectors
        x_vec_Full = x0_vec;                
        x_vec_curr = x0_vec;

        for (numIter = 2: 1: NMAX)
            x_vec_next = M_Jacobi * x_vec_curr + (D_Jacobi_Inv * b);
            x_vec_Full = [x_vec_Full, x_vec_next];   %concat to solution
        
            if(ComputeInfinityNorm(x_vec_curr, x_vec_next) < tol)
                break;
            end                        
            
            x_vec_curr = x_vec_next; %Get ready for next iteration
        end
        str = ['Jacobi: Number of iterations: ',num2str(numIter)];
        disp(str)
    end    
    
    %Double Check with Matlab Solution
    disp('Matlab solution')
    compareMatlab = A\b
    
end

function[result] = ComputeInfinityNorm(x_prev, x_new)
    x_diff = x_prev - x_new;
    result = norm(x_diff, inf);
end

function [status]  = WQ_CheckDiagDom(A)
    status = false;
    [maxRowSize, maxColSize] = size(A);

    %Read row by row
    str = '';
    for row = 1: 1: maxRowSize
        tempDiag = A(row,row);      

        sumNonDiag = 0;
        for col = 1: 1: maxColSize
            if(row ~= col)
                sumNonDiag = sumNonDiag + abs(A(row, col));
            end            
            %str = [str, ' ', num2str(A(row,col))];
        end
        sumNonDiag;
        if(abs(tempDiag) > sumNonDiag)
            status = true;
        else
            status = false;
            break;
        end
    end
end
