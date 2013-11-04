clear all;

data_load_script;

select = 2;
d = 13;

[test_target_variables, test_target_names, test_data, test_feature_names] = ...
load_HS_vaalikone('data/data_vk_test_full.csv');

[coeff, score] = pca(data);

cls = classify(test_data * coeff(:, 1:d), score(:, 1:d), ...
target_variables(:,select));

cls_v = cellfun(@(x) party_to_idx(x), cls);
truth_v = cellfun(@(x) party_to_idx(x), test_target_variables(:,select));

results = evaluate_2(cls_v, truth_v);
