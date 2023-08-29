function [n_sel, sel] = SBS(p_cf, p_ff, n_sel, sel,R, flg)

Jpre = correlationMeasure(p_ff, p_cf, sel, [], 0);

for i = 1:R
    
    Jf = zeros(1, numel(sel));
    for j = 1:numel(sel)
        Jf(j) = correlationMeasure(p_ff, p_cf, sel, j, 1);
    end
    
    [Jcur, id] = max(Jf);
    
    if abs(Jcur-Jpre)<0.002 && flg==1
        break
    else
        n_sel = [n_sel sel(id)];
        sel(id) = [];
        Jpre = Jcur;
    end
end