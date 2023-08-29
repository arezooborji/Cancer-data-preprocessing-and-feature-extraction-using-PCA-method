function acc = calAccuracy(dataTrain, lblTrain, dataTest, lblTest, sel)

dataTrain = dataTrain(:, sel);
dataTest = dataTest(:, sel);

lblp = knnclassify(dataTest, dataTrain, lblTrain, 3);
acc = sum(lblp==lblTest)/numel(lblTest);