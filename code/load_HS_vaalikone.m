function [target_variables, target_names, data, feature_names] = load_HS_vaalikone(fname)
    dt = importdata(fname);
    data = dt.data;

    % Header line is merged with labels, so remove it
    target_variables = dt.textdata(2:end, :);
    
    
    % Parse names
    parts=regexp(dt.textdata{1}(2:end-1), '","', 'split');
    % Omit the names of the labels
    target_names = parts(1:2);
    feature_names = parts(3:end);

