% savemem is an optional parameter
function [mHandle, obj, return_delta, return_gamma] = ...
                        create_bayes_gamma_model(training_data, ...
                        training_labels, savemem, delta, gamma)
    
    mHandle = @model;
    
    
    % default to savemem on, if user doesn't say otherwise
    if nargin < 3
        savemem = 1;
    end
    
    
    % Naive bayes classifier
    if savemem
        obj = ClassificationDiscriminant.fit(training_data, ...
            training_labels,'DiscrimType','linear', ...
            'SaveMemory','on','FillCoeffs','off');
    else
        obj = ClassificationDiscriminant.fit(training_data, ...
            training_labels,'DiscrimType','linear');
    end
    
    
     % run crossvalidation if delta and gamma are not given
    if nargin < 5
        
        % 29 means use 30 values
        [err,gamma,delta,numpred] = cvshrink(obj,...
            'NumGamma',9,'NumDelta',39);%,'Verbose',1);
        
        % plot or not
%         figure;
%         plot(err,numpred,'r.')
%         xlabel('Error rate');
%         ylabel('Number of predictors');
        
        % Find the values of Gamma and Delta that give minimal error.
        
        minerr = min(min(err));
        [p,q] = find(err == minerr);
        
        c_gamma = gamma(p(1));
        c_delta = delta(p(1),q(1));
        
        fprintf('Chosen Gamma: %.5f Delta: %.5f\n', c_gamma, c_delta);
        %disp('Chosen Gamma and Delta:');
        %[gamma(p(1)),delta(p(1),q(1))]
        fprintf('Num of predictors with nonzero coefficients: %d\n', ...
            numpred(p(1),q(1)));
        
        
        obj.Delta = delta(p(1),q(1));
        obj.Gamma = gamma(p(1));
        
    else % otherwise just set them
        obj.Delta = delta;
        obj.Gamma = gamma;
    end
    
    
    % return used delta and gamma
    return_delta = obj.Delta;
    return_gamma = obj.Gamma;
    
    function pred = model(test_data)
        pred = predict(obj, test_data);
    end
end