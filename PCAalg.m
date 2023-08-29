function W = PCAalg(Data, nData, nDimSel)

mu = mean(Data,1);  %calculate mean of data train
ST = 0;
for i = 1:nData
    x = (Data(i,:)-mu)';
    ST = ST + x*x';
end
[eigVec,eigValue]=eig(ST); %calculate eigen value and eigen vector
eigValue = diag(eigValue);
[~, idSort] = sort(eigValue, 'descend');

idSel = idSort(1:nDimSel);
W = eigVec(:, idSel); % tranform matrix