% ***** LAST DEVELOPER UPDATE : PWH 19.06.07  ***** %
function RunCarModel(src,event)

    global V_L V_R time_stack plot_var V_B
    
    V_L = event.Data(:,1);
    V_R = event.Data(:,2);
    V_B=event.Data(:,3);
    time_stack = event.TimeStamps ;
    
    [w_L w_R] = CmdCarModel(V_L(end), V_R(end),V_B(end));
    
    PlotCarModel(w_L, w_R);
    
end




