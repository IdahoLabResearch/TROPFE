function [Solved,Format] = giveBeehavior(casedata,mpopt)
    
    n=1;
    G = runopf(casedata,mpopt);
    [busO,branchO,genO]=fixOrder(casedata);
    %formRes formatted as all generators power,voltage then all loads
    abus = G.bus;
    abranch = G.branch;
    agen = G.gen;
    success = G.success;
    
    numgen = height(agen);
    numbus = height(abus);
    numbranch = height(abranch);
    numload = 0;

    
    j=1;

    formRes = [];
    
    k =1; %tracks position in formRes array 
    isLoad = zeros(numbus,1); %array of booleans (1or0) that indicates whether a bus in a certain position is a load
        
    order =[];
    for i = 1:numgen
        formRes(n,k) = agen(i,2);
        order = [order,'GenPower    '];
        k=k+1;
        buspos = genO(i);
        formRes(n,k) = abus(buspos,8)*abus(buspos,10);
        order = [order,'GenVoltage  '];
        k=k+1;
    end
    i=1;
    for i = 1:numbus
        if(abs(abus(i,3))>0)
            formRes(n,k) = abus(i,3);
            order = [order,'LoadPower   '];
            k=k+1;
            formRes(n,k) = abus(i,4);
            order = [order,'LoadReactivePower   '];
            k=k+1;
            numload = numload +1;
        end
    end


    z=0;
    
    for f = 1:numbranch
        z=0;
        frombus = abranch(f,1);
        if abranch(f,14) == 0 %is line in service boolean
            formRes(n,k) = 0;
        else    
            formRes(n,k) = 1; %is line in service boolean
        end
        order = [order,'inService?  '];
        k = k+1;
        formRes(n,k) = abranch(f,14); %power
        order = [order,'LinePower   '];
        k=k+1;
        formRes(n,k) = abranch(f,15); %reactive power
        order = [order,'LineReactivePower   '];
        k=k+1;
        formRes(n,k) = 0;
        z = sqrt(abranch(f,3)^2 + abranch(f,4)^2);%impedence z
        branchf = abranch(f,1); %figures what bus we get data from, the 'from bus' for the line in question
        branchfpos = branchO(f);
        if abs(z) > 0
            formRes(n,k) = (abus(branchfpos,8)*abus(branchfpos,10))/z; %should be current, voltage over impedence
            order = [order,'lineCurrent '];
            k=k+1;
        end
        formRes(n,k) = abus(branchfpos,8)*abus(branchfpos,10); %voltage pu * baseKV
        
        order = [order,'LineVoltage '];
        k=k+1;
        %MVA = sqrt(3)*formRes(k-1)*formRes(k-2);
        MVA = abranch(f,6)*1000/(sqrt(3)*abus(branchfpos,10)); %find MVA in volts
        
        if MVA > 0 %if there is no MVA dont calculate percent overload
            formRes(n,k) = (formRes(k-1)*100)/MVA;
        else
            formRes(n,k) = 0;
        end
        %formRes(k) = (abranch(f,14))/(abranch(f,6)*1*1); %PERCENT OVERLOAD
        order = [order,'PercentOverload '];
        
        k=k+1;
        %k=k+1;
    end
    formRes(n,k) = success;         % kill this line if the ML algorithmum doesn't like it
    order = [order,'Success?'];     % kill this line if the ML algorithmum doesn't like it

    Solved = formRes;
    Format = order;
end