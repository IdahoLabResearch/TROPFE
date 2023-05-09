function [busid,branchid,genid] = fixOrder(data)
    bus = data.bus;
    branch = data.branch;
    gen = data.gen;

    bidx = zeros(height(bus),1);
    bridx = zeros(height(branch),1);
    genidx = zeros(height(gen),1);
  
    for i = 1:height(bus)
        
        bidx(i) = i;

        for j = 1:height(branch)

            if(bus(i,1)==branch(j,1))
                bridx(j) = i;
            end
        end
        for k = 1:height(gen)
            if(bus(i,1)==gen(k,1))
                genidx(k) = i;
            end
        end
    end
    
    busid=bidx;
    branchid=bridx;
    genid = genidx;
end