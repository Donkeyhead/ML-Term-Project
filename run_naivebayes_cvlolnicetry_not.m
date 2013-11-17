
% run_naivebayes.m

%% Clear and init data
%clear all;
%data_load_script;


%% Crossvalidate (do what cvshrink does but do it with f-score)

numGamma = 25;
numDelta = 25;

tryGammas = 1e-5:1/numGamma:1;
tryDeltas = 0:1/numDelta:1;

num_data = size(data_target_labels, 1);

i = 1;
fscores = zeros(numGamma, numDelta);
for tg = tryGammas
    
    fprintf('Processing Gamma step %d out of %d.\n', i, numGamma);
    
    j = 1;
    for td = tryDeltas
        
        [~, obj] = create_naivebayes_model(data, ...
            party_to_idx_fun(data_target_labels), 1, td, tg);
        
        cvmodel = crossval(obj, 'kfold',num_data/20);
        
        fscores(i, j) = mean(kfoldfun(cvmodel,@kfoldFunFscore));
        
        j = j+1;
    end
    
    i = i+1;
end

% choose minimum ones
maxscore = max(max(errors));
[p,q] = find(errors == maxscore);

c_gamma = tryGammas(p);
c_delta = tryDeltas(q);

fprintf('MaxScore %.5f\n', maxscore);
fprintf('Verify %.5f\n', fscores(p, q));
fprintf('Chosen Gamma: %.5f Delta: %.5f\n', c_gamma, c_delta);


%% Create best model

nbmodel = create_naivebayes_model(data, ...
    party_to_idx_fun(data_target_labels), 1, c_delta, c_gamma);

%% Predict with best model

prediction = nbmodel(test_data);

results = evaluate_2(prediction, party_to_idx_fun(test_data_target_labels));

% show results
results{2}


% EOF
