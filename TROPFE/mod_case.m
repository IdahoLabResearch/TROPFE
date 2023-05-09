function M = mod_case(casedata,probability)

    [CT_LABEL, CT_PROB, CT_TABLE, CT_TBUS, CT_TGEN, CT_TBRCH, ...
        CT_TAREABUS, CT_TAREAGEN, CT_TAREABRCH, CT_ROW, CT_COL, CT_CHGTYPE, ...
        CT_REP, CT_REL, CT_ADD, CT_NEWVAL, CT_TLOAD, CT_TAREALOAD, ...
        CT_LOAD_ALL_PQ, CT_LOAD_FIX_PQ, CT_LOAD_DIS_PQ, CT_LOAD_ALL_P, ...
        CT_LOAD_FIX_P, CT_LOAD_DIS_P, CT_TGENCOST, CT_TAREAGENCOST, ...
        CT_MODCOST_F, CT_MODCOST_X] = idx_ct;

    [GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;

    [F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, ...
    RATE_C, TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

    [PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;

     
    prob1 = rand(1);
    prob2 = rand(1);

    line = randi(height(casedata.branch));
    gen = randi(height(casedata.gen));
    changed1 = 0;
    changed2 = 0;
   
    contab = [ %contab sets contingency changes to cases, more info with 'help apply_changes' or in MATPOWER manual
            1   0.1   CT_TGEN           gen  GEN_STATUS        CT_REP     0;
            2   0.1   CT_TBRCH          line     BR_STATUS         CT_REP      0;
            ];

    %the second col of contab that applies probability of occurence didnt seem to be doing anything so i applied my own 
    if(prob1 < probability) % (probability*100)% chance of gen power / gen status being set to zero
        M = apply_changes(1,casedata,contab);
        changed1 = 1;
    end
    
    if prob2 < probability && changed1 == 1 % (probability*100)% chance of branch power / branch status being set to zero
        M = apply_changes(2,M,contab);
        changed2=1;
    elseif prob2 < probability
        M = apply_changes(2,casedata,contab);
        changed2=1;
    end

    if changed1 == 0 && changed2 == 0
        M = casedata;
    end
   
end