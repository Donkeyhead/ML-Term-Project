
% run_naivebayes.m

rng(8000, 'twister');  % set rng

%% Clear and init data
%clear all;
%data_load_script;

truth = party_to_idx_fun(test_data_target_labels);


%% Crossvalidate for PCA dimensions (and delta + gamma)

pcaDims = 1:80;
[coeff, score] = pca(data);
targets = party_to_idx_fun(data_target_labels);

fscores = zeros(1, length(pcaDims));
deltas  = zeros(1, length(pcaDims));

i = 1;
for deg = pcaDims
    
    fprintf('Processing dimension %d, %d out of %d.\n', deg, i, ...
        length(pcaDims));
    
    [trymodel, tryobj, found_delta] = create_naivebayes_model( ...
        data*coeff(:, 1:deg), targets);
    
    cvmodel = crossval(tryobj, 'kfold',length(targets)/25);
    fscores(1, i) = mean(kfoldfun(cvmodel,@kfoldFunFscore));
    
%     prediction = trymodel(test_data*coeff(:, 1:deg));
% 
%     r = evaluate_2(prediction, truth);
%     r2 = r{2};
%     fscores(1, i) = r2(1,1);
%     deltas(1, i) = found_delta;
%     
%     fprintf('FScore was %.4f\n', r2(1,1));
    
    i = i+1;
end

maxscore = max(fscores);
idxs = find(fscores == maxscore);
best_deg = pcaDims(idxs(1));
best_delta = deltas(idxs(1));
best_coeff = coeff(:, 1:best_deg);

fprintf('MaxScore %.5f\n', maxscore);
fprintf('Chosen degree: %d\n', best_deg);
fprintf('Chosen delta: %d\n', best_delta);

%% Create best model

nbmodel = create_naivebayes_model(data*best_coeff, ...
    party_to_idx_fun(data_target_labels), 1, best_delta);

%% Predict with best model

prediction = nbmodel(test_data*best_coeff);

results = evaluate_2(prediction, truth);

% show results
results{2}


% EOF
