clc
clear
warning off

% Load data
a = importdata('data.csv');
data = a.data;
[nData, nFea] = size(data);
lbl = zeros(nData,1);
for i = 1: nData
    if strcmp(a.textdata{i+1,2},'M')
        lbl(i) = 1;
    elseif strcmp(a.textdata{i+1,2},'B')
        lbl(i) = 2;
    end
end

% Processes matrices by normalizing the minimum and maximum values of each column to [YMIN, YMAX].
ymin = 0;
ymax = 1;
for i = 1:nFea
    xmin = min(data(:,i));
    xmax = max(data(:,i));
    
    data(:,i) = (ymax-ymin)*(data(:,i)-xmin)./(xmax-xmin) + ymin;
end

% Generate randomly train data and test data
cv = cvpartition(lbl,'holdout',0.3);
lblTrain = lbl(cv.training);
dataTrain = data(cv.training, :);

lblTest = lbl(cv.test);
dataTest = data(cv.test, :);


p_cf = zeros(1, nFea);
for i=1:nFea
    p_cf(i) = corr(dataTrain(:,i), lblTrain);
end

p_ff  = zeros(nFea, nFea);
for j=1:nFea
    for i=1:nFea
        if i==j
            continue
        end
        p_ff(j,i)=corr(dataTrain(:,j),dataTrain(:,i));
    end
end


% run Sequential backward selection
K = 29;
no_sel_SBS = [];
sel_SBS = 1:nFea;
[no_sel_SBS, sel_SBS] = SBS(p_cf, p_ff, no_sel_SBS, sel_SBS, K, 1);


acc_SBS = calAccuracy(dataTrain, lblTrain, dataTest, lblTest, sel_SBS);

% Run LRS selection
i = 1;
for L = 4:2:20
    for R = 4:2:20
        if L==R
            continue
        end
        [result(i).acc, result(i).sel] = LRS(L, R, nFea, p_ff, p_cf, dataTrain, lblTrain, dataTest, lblTest);
        result(i).LR = [L R];
        i = i+1;
    end
end

[acc_LRS, ind] = max([result.acc]);
sel_LRS = result(ind).sel;
LR =  result(ind).LR;

% Run PCA
nDimSel = 5;
W = PCAalg(dataTrain, numel(lblTrain), nDimSel);

dataTrain = dataTrain*W;
dataTest = dataTest*W;

lblp = knnclassify(dataTest, dataTrain, lblTrain, 3);
acc_PCA = sum(lblp==lblTest)/numel(lblTest);



disp('------- show result -----')
disp(' selected features with Sequential backward selection is: ')
disp(sel_SBS)
disp(['accuracy with  Sequential backward selection is ' num2str(acc_SBS)])
disp(' ======================================================')
disp(['L= ' num2str(LR(1)) '  and R='  num2str(LR(2))])
disp(' selected features with Plus-L minus-R selection is: ')
disp(sel_LRS)
disp(['accuracy with  Plus-L minus-R selection is ' num2str(acc_LRS)])
disp(' ======================================================')
disp(['number of feature in PCA is ' num2str(nDimSel)])
disp(['accuracy with  PCA is ' num2str(acc_PCA)])
