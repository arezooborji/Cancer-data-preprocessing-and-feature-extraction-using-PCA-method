function Jf = correlationMeasure(p_ff, p_cf, sel, j, type)
if type ==1
    sel(j) = [];
elseif type ==2
    sel = [sel j];
end
if numel(sel)==1
    Jf = p_cf(sel);
else
    tot = 0;
    for i1 = 1:numel(sel)
        for j1 = i1+1:numel(sel)
            tot = tot + p_ff(sel(i1), sel(j1));
        end
    end
    k = numel(sel);
    Jf = sum(p_cf(sel))/ sqrt(k + 2*tot);
end