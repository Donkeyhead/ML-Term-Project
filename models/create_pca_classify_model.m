function [mHandle] = create_pca_classify_model(training_data, training_labels)

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
        deg
        pred = classify(test_data * coeff(:,1:deg), score(:, 1:deg), training_labels);
    end
end