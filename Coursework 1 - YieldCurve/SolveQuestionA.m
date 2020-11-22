function[] = SolveQuestionA(in_dates_vec, in_rates_vec)
    [in_dates_vec, in_rates_vec] = ProcessDatesAndRates(nargin);

    %Process Dates and Rates into (xi,yi)
    [dcf_vec] = ComputeDayCountFractions(in_dates_vec);    
      
    %Solve for Cubic Spline Coefficients and Curves
    colour = 'k'    %black 
    Sx_vec = WQ_CubicSpline(dcf_vec, in_rates_vec, colour);
end

function[out_x_vec] = ComputeDayCountFractions(in_D_vec)
    startDate = in_D_vec(1);    
    out_x_vec = daysact(startDate, in_D_vec)  / 365;
end

function[out_x_vec, out_y_vec] = ProcessDatesAndRates(inCount)
    clc
    if(inCount == 0)
    %Question 1 Dates
        DateStrings = {'01-Nov-2016';	'08-Dec-2016';	'09-Mar-2017';	
                                    '08-Jun-2017';	'07-Sep-2017';	'07-Dec-2017';	
                                    '08-Mar-2018';	'07-Jun-2018';	'13-Sep-2018'};	
        out_x_vec = datetime(DateStrings,'InputFormat','dd-MMM-yyyy') ;
    end    
        
    if(inCount <=1)
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