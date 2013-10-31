clear all;

select = 1;
deg = 25;

data_load_script;

[test_target_variables, test_target_names, test_data, test_feature_names] = ...
load_HS_vaalikone('data/data_vk_test_full.csv');

[coeff, score] = pca(data_questions);
cls = classify(test_data(:, idx_questions) * coeff(:, 1:deg), score(:, 1:deg), ...
target_variables(:,select));

cls_v = cellfun(@(x) x, cls);
truth_v = cellfun(@(x) x, test_target_variables(:,select));

results = evaluate(cls_v, truth_v);
