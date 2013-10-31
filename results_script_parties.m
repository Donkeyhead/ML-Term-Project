clear all;

select = 2;

data_load_script;

[test_target_variables, test_target_names, test_data, test_feature_names] = ...
load_HS_vaalikone('data/data_vk_test_full.csv');

[coeff, score] = pca(data_questions);
cls = classify(test_data(:, idx_questions) * coeff(:, 1:8), score(:, 1:8), ...
target_variables(:,select));

cls_v = cellfun(@(x) party_to_idx(x), cls);
truth_v = cellfun(@(x) party_to_idx(x), test_target_variables(:,select));

results = evaluate(cls_v, truth_v);
