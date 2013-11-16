
%% Run results_script_parties
results_script_parties;

% save stuff from results_script_parties
res_parties = results{2};
fscore_parties = res_parties(3:end, 1);
pred_parties = cls_v;

% real labels
real_labels = truth_v;

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
    pred2 = pred_mvnpdf(i);
    
    if fscore_parties(pred1) < fscore_mvnpdf(pred2)
        pred_hybrid(i) = pred2;
    else
        pred_hybrid(i) = pred1;
    end
end

%% Evaluate

results = evaluate_2(pred_hybrid, real_labels);

r = results{2};

[r(3:end, 1), fscore_parties, fscore_mvnpdf]

% EOF
