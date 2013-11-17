function fscoreCost = kfoldFunFscore(CMP,Xtrain,Ytrain,Wtrain, ...
                                         Xtest,Ytest,Wtest)
    % F-Score for kfoldFun in Matlab
    % http://www.mathworks.se/help/stats/classificationpartitionedmodel.kfoldfun.html
    pred = predict(CMP, Xtest);
    
    %whos cmp Xtrain Ytrain Xtest Ytest
    
    results = evaluate_2(pred, Ytest);
    r2 = results{2};
    fscoreCost = r2(1,1);
end
