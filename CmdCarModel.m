function [w_L w_R] = CmdCarModel(V_in_L, V_in_R, V_in_B)
    % Converting Input Signal(Sensor) to Command Signal(Car)
    global ypr open_data1 open_data2 open_data3 close_data1 close_data2 close_data3 flt_data_1 flt_data_2 flt_data_3 avg_data_1 avg_data_2 avg_data_3

    flt_data_1  = [flt_data_1(2:6) V_in_L];
    avg_data_1 = mean(flt_data_1)
   
    flt_data_2  = [flt_data_2(2:6) V_in_R];
    avg_data_2 = mean(flt_data_2)
    
    flt_data_3  = [flt_data_3(2:6) V_in_B];
    avg_data_3 = mean(flt_data_3)
    
    w_L = 2;
    w_R = 2;
    
    if(V_in_B < open_data3+(close_data3 - open_data3)/2)
        if(avg_data_1>(open_data1+close_data1)/2)
            w_L = 4;
        end
        
         if(avg_data_2>(open_data2+close_data2)/2)
            w_R = 4;
         end
    else
        w_L = -2;
        w_R = -2;
    end
    
end