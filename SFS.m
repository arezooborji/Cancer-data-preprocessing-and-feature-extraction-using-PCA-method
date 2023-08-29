function [no_sel, sel, Jcur] = SFS(p_cf, p_ff, no_sel, sel,L)

for i = 1:L
    
    Jf = zeros(1, numel(no_sel));
    for j = 1:numel(no_sel)
        Jf(j) = correlationMeasure(p_ff, p_cf, sel, no_sel(j), 2);
    end
    
    [Jcur, id] = max(Jf);
    
    sel = [sel no_sel(id)];
    no_sel(id) = [];
    
end
