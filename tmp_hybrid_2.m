
%% Run results_script_parties
results_script_parties;

% save stuff from results_script_parties
res_parties = results{2};
fscore_parties = res_parties(3:end, 1);
pred_parties = cls_v;

% real labels
real_labels = truth_v;


%% Naive bayes classifier (linear)

obj = ClassificationDiscriminant.fit(data_questions, ...
    data_target_labels,'DiscrimType','diagLinear');

pred_naive = party_to_idx_fun(predict(obj, test_data_questions));
tmp = evaluate_2(pred_naive, real_labels);
res_naive = tmp{2};
fscore_naive = res_naive(3:end, 1);


%% Run tmp_mvnpdf_party
tmp_mvnpdf_party;

res_mvnpdf = results{2};
fscore_mvnpdf = res_mvnpdf(3:end, 1);
pred_mvnpdf = cellfun(@(x) x, member_prediction);


%% Make it hybrid nonsense

% allocate
pred_hybrid = zeros(length(real_labels), 1);

for i=1:length(real_labels)
    pred1 = pred_parties(i);
    pred2 = pred_naive(i);
    pred3 = pred_mvnpdf(i);
    pred4 = pred_bag(i); % HOX pred_bag make by hand
    prr = [pred1, pred2, pred3, pred4];
    
    % nnets
    for j=1:length(parties)
        tmpp = bin_prediction{j};
        if tmpp(i)
            prr(end + 1) = j;
        end
    end
    % end nnets
    
    [~,~,C] = mode(prr);
    
    if(length(C{1}) > 1)
        [~, chosen_idx] = max([fscore_parties(pred1), ...
            fscore_naive(pred2), fscore_mvnpdf(pred3), ...
            fscore_bag(pred4)]); % HOX fscore_bag make by hand
        pred_hybrid(i) = prr(chosen_idx);
    else
        pred_hybrid(i) = C{1};
    end
    
    
end

%% Evaluate

results = evaluate_2(pred_hybrid, real_labels);

r = results{2};

[r(3:end, 1), fscore_parties, fscore_naive, fscore_mvnpdf, fscore_bag]

% EOF
