mpc = loadcase(case9241pegase);

mpopt = mpoption('pf.alg','NR', 'verbose', 0,'pf.tol',1e-8);
tic
runopf(mpc, mpopt);
NR = toc;
disp('Done with NR')

mpopt = mpoption('pf.alg','FDXB', 'verbose', 0, 'pf.tol',1e-8);
tic
runopf(mpc, mpopt);
FDXB = toc;
disp('Done with FDXB')

mpopt = mpoption('opf.ac.solver','PDIPM', 'pdipm.step_control', 1, 'verbose', 0,'pf.tol',1e-8);
tic
runopf(mpc, mpopt);
PDIPM = toc;
disp('Done with PDIPM')

% mpopt = mpoption('opf.ac.solver','MINOPF', 'verbose', 0);
% tic
% runopf(mpc, mpopt);
% MINO = toc;
% disp('Done with NR')

mpopt = mpoption('opf.dc.solver','GUROBI', 'verbose', 0,'pf.tol',1e-8);
tic
runopf(mpc,mpopt)
DC = toc;
disp('Done with DC approximation')

times = [NR,FDXB,PDIPM,DC]
