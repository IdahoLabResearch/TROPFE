mpc = loadcase(case9241pegase);
step = 1;
n = 100;

NR = zeros(1,100);
k=1;
mpopt = mpoption('model', 'AC', 'pf.alg','NR', 'verbose', 1,'pf.tol',1e-8);
for a = 1:step:n
    tic
    stack(mpc,mpopt,1,0);
    NR(k) = toc;
    k=k+1;
end
disp('Done with NR')

FDXB = zeros(1,100);
k=1;
mpopt = mpoption('model', 'AC', 'pf.alg','FDXB', 'verbose', 1, 'pf.tol',1e-8);
for a = 1:step:n
    tic
    stack(mpc,mpopt,1,0);
    FDXB(k) = toc;
    k=k+1;
end
disp('Done with FDXB')

PDIPM = zeros(1,100);
k=1;
mpopt = mpoption('model', 'AC', 'opf.ac.solver','PDIPM', 'verbose', 1,'pf.tol',1e-8);
for a = 1:step:n
    tic
    stack(mpc,mpopt,1,0);
    PDIPM(k) = toc;
    k=k+1;
end
disp('Done with PDIPM')

% mpopt = mpoption('opf.ac.solver','MINOPF', 'verbose', 0);
% tic
% runopf(mpc, mpopt);
% MINO = toc;
% disp('Done with NR')

DC = zeros(1,100);
k=1;
mpopt = mpoption('model', 'DC','opf.dc.solver','MIPS', 'verbose', 1,'pf.tol',1e-8);
for a = 1:step:n
    tic
    stack(mpc,mpopt,1,0);
    DC(k) = toc;
    k=k+1;
end
disp('Done with DC approximation')

times = [NR;FDXB;PDIPM;DC];
csvwrite('9241data.csv',times)
