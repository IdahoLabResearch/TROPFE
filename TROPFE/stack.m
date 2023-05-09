function S = stack(casedata,mpopt,num,problemProb)
    tic;
    final = [];
    
    G = runopf(casedata,mpopt);
    [busO,branchO,genO]=fixOrder(casedata);

    %newcase = mod_case(casedata,problemProb);
  
    for i = 1:num
        newcase = mod_case(casedata,problemProb);
        [row, top] = giveBeehavior(newcase,mpopt);
        final = [final;row];
    end

    S = final;
    format = fopen('TROPFE Formatted Output','w');
    fprintf(format,'%s',top);
    fprintf(format,'\n');
    for x = 1:num
        fprintf(format,'%5.5g\t',final(x,:));
        fprintf(format,'\n');
    end
    save('trainer.mat','final');
toc;
end
     