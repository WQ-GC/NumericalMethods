function[] = SolveQuestionB(in_dates_vec, in_rates_vec)
    [in_dates_vec, in_rates_vec] = ProcessDatesAndRates(nargin);

    %Process Dates and Rates into (xi,yi)
    [dcf_vec] = ComputeDayCountFractions(in_dates_vec);    
      
    %Solve for Cubic Spline Coefficients and Curves
    colour = 'r' 
    Sx_vec = WQ_CubicSpline(dcf_vec, in_rates_vec, colour);
    
    %Search for T1 == 01 May 2018
    SearchT1Spline(dcf_vec, Sx_vec)
    
end

function[] = SearchT1Spline(in_dcf_vec, in_Sx_vec)
    today = {'01-Nov-2016'};
    lastFuturesDate = {'12-Oct-2018'};
    t1 = {'01-May-2018'};
    today = datetime(today,'InputFormat','dd-MMM-yyyy');
    lastFuturesDate = datetime(lastFuturesDate,'InputFormat','dd-MMM-yyyy');
    t1 = datetime(t1,'InputFormat','dd-MMM-yyyy'); 

    if(t1 < today)
        %t1 is earlier than today
        return;        
    end
    
    if(t1 > lastFuturesDate)
        %t1 is later than last futures date
        return;        
    end
    
    t1_dcf = daysact(today, t1)  / 365;
    
    [numPts,getCol] = size(in_dcf_vec);
    for(i = 1: 1:numPts)
        if(in_dcf_vec(i) > t1_dcf)
            break;
        end
    end

    %t1 is between in_dcf_vec(i-1) & in_dcf_vec(i) 
    syms f(x);
    f(x) = in_Sx_vec(i);
    PV = 10000000 * (double(f(t1_dcf)) - 1.964) * 0.25 / 100;
    hold on;       
    plot(t1_dcf, double(f(t1_dcf)), "bd", 'LineWidth',3);    
    str = ['\leftarrowRF (' , num2str(t1_dcf), ',', num2str(double(f(t1_dcf))), '%)' ];
    text(t1_dcf + 0.05, double(f(t1_dcf)),str)
    hold off;          

    format long
    str = ['RF at T1 (01-May-2018) is:  ', num2str(double(f(t1_dcf))),'%'];
    disp(str)

    str = ['PV at T1 (01-May-2018) is: ', num2str(PV)];        
    disp(str)
    
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