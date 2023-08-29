function [acc_LRS, sel_LRS] = LRS(L, R, nFea, p_ff, p_cf, dataTrain, lblTrain, dataTest, lblTest)

if L>R
    no_sel =1:nFea;
    sel_LRS = [];
    Jpre = 0;
elseif L<R
    no_sel = [];
    sel_LRS = 1:nFea;
    Jpre = correlationMeasure(p_ff, p_cf, sel_LRS, [], 0);
end

for it = 1:15
    
    if L>R
        [no_sel, sel_LRS] = SFS(p_cf, p_ff, no_sel, sel_LRS,L);
        [no_sel, sel_LRS] = SBS(p_cf, p_ff, no_sel, sel_LRS, R, 0);
        
    elseif L<R
        if numel(sel_LRS)<R
            break
        end
        [no_sel, sel_LRS] = SBS(p_cf, p_ff, no_sel, sel_LRS, R, 0);
        [no_sel, sel_LRS] = SFS(p_cf, p_ff, no_sel, sel_LRS,L);
    end
    Jcur = correlationMeasure(p_ff, p_cf, sel_LRS, [], 0);
    if abs(Jcur-Jpre)<0.002
        break
    else
       Jpre = Jcur;
    end
    
end

acc_LRS = calAccuracy(dataTrain, lblTrain, dataTest, lblTest, sel_LRS);

