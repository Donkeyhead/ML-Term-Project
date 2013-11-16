
%% MVNPDF's for the parties

used_data = data_questions;
used_test = test_data_questions;

%% TEST: DO PCA

deg = 8; % magic num
[coeff, score] = pca(used_data);

used_data = used_data*coeff(:,1:deg);
used_test = used_test*coeff(:,1:deg);

%% Init vars

muS = cell(length(parties), 1);
sigmaS = cell(length(parties), 1);
party_sample_idxs = cell(length(parties), 1);

whos used_data used_test

%% Calculate mvn parameters mu and sigma for each party
for i=1:length(parties)
    
    i
    
    full_data = used_data(party_members{i},:);
    
    whos full_data
    
    % Remove linear dependencies
    [training_set, removed_col_idxs, saved_col_idxs] = ...
        remove_linear_deps(full_data);
    
    whos training_set removed_col_idxs
    %removed_col_idxs
    %saved_col_idxs
    
    % Calculate mu and sigma
    muS{i} = mean(training_set);
    sigmaS{i} = cov(training_set);
    party_sample_idxs{i} = saved_col_idxs;
end

whos muS sigmaS party_sample_idxs

%% Calculate probabilities of belonging to a party

party_probability = cell(length(parties), 1);

for i=1:length(parties)
    
    i
    
    sample = used_test(:,party_sample_idxs{i});
    
    mu = muS{i};
    sigma = sigmaS{i};
    whos sample mu sigma
    rank(sigma);
    
    party_probability{i} = mvnpdf(sample, muS{i}, sigmaS{i});
end


%% Predict label

% probability of each party for each candidate
probabilities = cell(size(used_test,1), 1);
member_prediction = cell(size(used_test,1), 1);

for i=1:size(used_test, 1)
    probas = zeros(length(parties), 1);
    for j=1:length(parties)
        party_probas = party_probability{j};
        probas(j) = party_probas(i);
    end
    probabilities{i} = probas;
    
    whos probas
    probas
    
    [~, member_pred] = max(probas); % choose party with greatest prob
    member_prediction{i} = member_pred;
    
    whos member_pred
    member_pred
end


%% Evaluate predicted labels

targets = party_to_idx_fun(test_data_target_labels);
pred = cellfun(@(x) x, member_prediction);

results = evaluate_2(pred, targets);

results{3}
results{2}

% EOF
