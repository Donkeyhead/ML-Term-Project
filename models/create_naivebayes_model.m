% savemem is an optional parameter
function [mHandle, obj, return_delta] = create_naivebayes_model( ...
                        training_data, training_labels, savemem, delta)
    mHandle = @model;
    
    
    % default to savemem on, if user doesn't say otherwise
    if nargin < 3
        savemem = 1;
    end
    
    
    % Naive bayes classifier
    if savemem
        obj = ClassificationDiscriminant.fit(training_data, ...
            training_labels,'DiscrimType','diagLinear', ...
            'SaveMemory','on','FillCoeffs','off');
    else
        obj = ClassificationDiscriminant.fit(training_data, ...
            training_labels,'DiscrimType','diagLinear');
    end
    
    
     % run crossvalidation if delta is not given
    if nargin < 4
        
        % 29 means use 30 values
        [err,~,delta,~] = cvshrink(obj,...
            'gamma',1,'NumDelta',99,'Verbose',1);
        
        % Find the value of Delta that gives minimal error.
        
        minerr = min(err);
        p = find(err == minerr);
        
        c_delta = delta(p(1));
        
        fprintf('Chosen Delta: %.5f\n', c_delta);
        
        obj.Delta = delta(p(1));
        
    else % otherwise just set delta
        obj.Delta = delta;
    end
    
    % return used delta
    return_delta = obj.Delta;
    
    function pred = model(test_data)
        pred = predict(obj, test_data);
    end
end