
function [prediction, posterior] = predict_classify(training_data, training_target, sample, pca_degree)
    
    d = pca_degree;
    
    if d ~= 0 % do pca
        [coeff, score] = pca(training_data);
        [prediction, ~, posterior] = classify(sample * coeff(:, 1:d), ...
            score(:, 1:d), training_target);
    else % no pca
        whos sample training_data training_target
        [prediction, ~, posterior] = classify(sample, ...
            training_data, training_target);
    end
    
    %[coeff, score] = pca(training_data);
    
    %[prediction, ~, posterior] = classify(sample * coeff(:, 1:d), ...
    %    score(:, 1:d), training_target);
    
end
