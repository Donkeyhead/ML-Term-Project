function [deg, errors] = create_model_PCA(data, data_labels, classes)
    
    degree_of_projections = 20;
    
    % create a map for the classes
    class_to_num = containers.Map(classes, 1:length(classes));

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

        validation_labels = cellfun(@(x) class_to_num(x), ...
        data_labels(validation_idx));
        training_labels = cellfun(@(x) class_to_num(x), ...
        data_labels(training_idx));
        
        [coeff, score] = pca(training_set);
       
        for d = 1:degree_of_projections
            new_d = score(:,1:d);

            % Which way is this even supposed to be multiplied?
            class_t = classify(training_set*coeff(:, 1:d), new_d, ... 
            training_labels);
            class_v = classify(validation_set*coeff(:, 1:d), new_d, ...
            training_labels);
            
            [~,~,~,~,Fscore] = getcm(training_labels, class_t, ...
            1:length(classes));

            t_error = mean(Fscore);

            [~,~,~,~,Fscore] = getcm(validation_labels, class_v, ...
            1:length(classes));
            Fscore
            v_error = mean(Fscore);

            %Magic!
            alp = 0; 

            errors(d, 1) = t_error + alp;
            errors(d, 2) = v_error + alp;
        end
    end


    errors = errors;
    [minerr, deg] = min(errors(:,2));
    plot([1:degree_of_projections], errors(:,1), 'ro');
    hold on
    plot([1:degree_of_projections], errors(:,2), 'bo');

    plot([1:degree_of_projections], (errors(:,2) + errors(:,1)) / 2, 'go');
    hold off
end
