function [cof] = corr(x,y)

cof = sum(x.*y)/sqrt(sum(x.^2)*sum(y.^2) );