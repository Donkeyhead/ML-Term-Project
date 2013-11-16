
%%

real_labels = party_to_idx_fun(test_data_target_labels);

%% Naive bayes classifier (linear)

obj = ClassificationDiscriminant.fit(data_questions, ...
    data_target_labels,'DiscrimType','diagLinear');

pred_naive = party_to_idx_fun(predict(obj, test_data_questions));
tmp = evaluate_2(pred_naive, real_labels);
res_naive = tmp{2};
fscore_naive = res_naive(3:end, 1);


%% Make it hybrid nonsense

% allocate
pred_hybrid = zeros(length(real_labels), 1);

for i=1:length(real_labels)
    % nnets
    nnet_preds = zeros(1, length(parties));
    for j=1:length(parties)
        tmpp = bin_prediction{j};
        if tmpp(i)
            nnet_preds(j) = 1;
        end
    end
    
    if sum(nnet_preds) == 1
        pred_hybrid(i) = find(nnet_preds == 1);
    % end nnets
    else
        pred_hybrid(i) = pred_naive(i);
    end
end

%% Evaluate

results = evaluate_2(pred_hybrid, real_labels);

r = results{2};

[r(3:end, 1), fscore_naive, maxFScores']

% EOF
