function [rtrn] = create_model_PCA_mvn(data, data_labels)
    
    degree_of_projections = 60;
    
    % Init the indices to partition
    N = size(data, 1);
    parts = 200;
    K = N / parts;
    indices = crossvalind('Kfold', N, K);
    
    errors = zeros(degree_of_projections, 2);
    for i=1:K

        % Partition the set
        validation_idx = find(indices == i);
        training_idx = find(indices ~= i);    
        
        validation_set = data(validation_idx, :);
        training_set = data(training_idx, :);

        validation_labels = data_labels(validation_idx);
        training_labels = data_labels(training_idx);
        
        [coeff, score] = pca(training_set);
        

        for d = 1:degree_of_projections
            new_d = score(:,1:d);

            % Which way is thisi even supposed to be multiplied?
            class_t = classify(training_set*coeff(:, 1:d), new_d, ... 
            training_labels);
            class_v = classify(validation_set*coeff(:, 1:d), new_d, ...
            training_labels);
            
            t_error = sum(strcmp(class_t, training_labels) == 0);

            v_error = sum(strcmp(class_v, validation_labels) == 0);

            errors(d, 1) = t_error;% + d / degree_of_projections * 0.5;
            errors(d, 2) = v_error;% + d / degree_of_projections * 0.5;
        end
    end
    errors = errors/K
    plot([1:degree_of_projections], errors(:,1), 'ro');
    hold on
    plot([1:degree_of_projections], errors(:,2), 'bo');

    plot([1:degree_of_projections], (errors(:,2) + errors(:,1)) / 2, 'go');
    hold off
end
