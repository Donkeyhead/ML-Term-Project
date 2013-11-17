
% run_bayes_gamma.m

rng(8001, 'twister');  % set rng

%% Clear and init data
%clear all;
%data_load_script;

truth = party_to_idx_fun(test_data_target_labels);


%% Crossvalidate for PCA dimensions (and delta + gamma)

%pcaDims = 30:90;
pcaDims = 100:180;
start = pcaDims(1);
[coeff, score] = pca(data);
targets = party_to_idx_fun(data_target_labels);

fscores = zeros(1, start+length(pcaDims));
deltas  = zeros(1, start+length(pcaDims));
gammas  = zeros(1, start+length(pcaDims));

%i=1;
parfor deg = pcaDims
    
    %fprintf('Processing dimension %d, %d out of %d.\n', deg, i, ...
    %    length(pcaDims));
    fprintf('Processing dimension %d.\n', deg);
    
    [trymodel, tryobj, trydelta, trygamma] = create_bayes_gamma_model( ...
        data*coeff(:, 1:deg), targets);
    
    gammas(1, deg) = trygamma;
    deltas(1, deg) = trydelta;
    
    cvmodel = crossval(tryobj, 'kfold',length(targets)/30);
    fscores(1,deg) = mean(kfoldfun(cvmodel,@kfoldFunFscore));
    
%     prediction = trymodel(test_data*coeff(:, 1:deg));
% 
%     r = evaluate_2(prediction, truth);
%     r2 = r{2};
%     fscores(1, i) = r2(1,1);
%     deltas(1, i) = found_delta;
%     
%     fprintf('FScore was %.4f\n', r2(1,1));
    
    %i = i+1;
end

maxscore = max(fscores);
idxs = find(fscores == maxscore);
best_deg = idxs(1);
best_delta = deltas(idxs(1));
best_gamma = gammas(idxs(1));
best_coeff = coeff(:, 1:best_deg);

fprintf('MaxScore %.5f\n', maxscore);
fprintf('Chosen degree: %d\n', best_deg);
fprintf('Chosen delta: %d\n', best_delta);
fprintf('Chosen gamma: %d\n', best_gamma);

%% Create best model

bgmodel = create_bayes_gamma_model(data*best_coeff, ...
    party_to_idx_fun(data_target_labels), 1, best_delta, best_gamma);

%% Predict with best model

prediction = bgmodel(test_data*best_coeff);

results = evaluate_2(prediction, truth);

% show results
results{2}

plot(pcaDims, fscores(pcaDims), 'kx');

% EOF
