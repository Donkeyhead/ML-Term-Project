function [mHandle] = create_pca_classify_model(training_data, data_labels, classes)
    whos data_labels
    whos classes
    class_to_num = containers.Map(classes, 1:length(classes));
    labels = cellfun(@(x) class_to_num(x), data_labels);

    mHandle = @model;
    
    function pred = model(test_data, perc)
        [coeff, score, ~, ~, expected] = pca(training_data);
        deg = 1;
        old_sum = 0;
        
        for i = 1:size(expected,1)
            deg = i;
            new_sum = sum(expected(1:i));
            if (new_sum - old_sum < perc)
                break
            end
            old_sum = new_sum;
        end
        pred = classify(test_data * coeff(:,1:deg), score(:, 1:deg), labels);        
    end
end