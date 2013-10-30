
function [target_variables, target_names, data, feature_names] = load_HS_vaalikone_test(flabels, fdata)
    % usage:
    % [test_target_variables, test_target_names, test_data, test_feature_names] = load_HS_vaalikone_test('data/data_vk_test-labels_only.csv', 'data/data_vk_test-data_only.csv');

    dt = importdata(fdata);
    data = dt.data;
    
    lbl = importdata(flabels);

    target_variables = lbl(2:end, :);
    
    
    % Parse names
    parts=regexp(dt.textdata{1}(2:end-1), '","', 'split');
    % Omit the names of the labels
    target_names = parts(1:2);
    feature_names = parts(3:end);

    