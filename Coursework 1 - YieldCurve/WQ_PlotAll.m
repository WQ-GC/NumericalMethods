function[] = WQ_PlotAll(in_x_vec, in_y_vec, in_Sx, numSplineSegments, in_colour)
    RESOLUTION_X = 0.01;
    
    if(nargin == 0)
        in_x_vec = GetRandomX();
    end
    
    if(nargin <= 1)
        in_y_vec = GetRandomY();
    end    

    if(nargin <= 2)
        disp('Error: No Spline curve provided')
        return
    end    

    if(nargin <= 3)
        disp('Error: No Spline segments provided')
        return
    end    

    if(nargin <= 4)
        in_colour = 'r';
    end    
    
    
    %Raw data points
    plot(in_x_vec, in_y_vec, "ro", 'LineWidth',2);
    title('3M Yield Curve (Cubic Spline)')  
    xlabel('Day Count Fraction [as a fraction of 365 days]')
    ylabel('Interest Rate [%]')
    
    hold on

    %Piecewise Linear
    %plot(in_x_vec, in_y_vec, "k"); %, 'LineWidth',0);
    %hold on
    
    %Cubic Spline Piecewise Plot
    startX = in_x_vec(1);    
    for(i = 1: 1:numSplineSegments)
        endX = in_x_vec(i+1);%this interval end        
        iterX = startX: RESOLUTION_X : endX; %0.01 resolution
        syms f(x);
        f(x) = in_Sx(i);
        iterY = f(iterX);
        plot(iterX, iterY, in_colour, 'LineWidth',1);
        hold on;       
        startX = endX; %next interval start
    end    
    
    hold off;    
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