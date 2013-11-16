
% mvnpdf models for all parties,
% k-fold validation for each party on what features to take
%     or how many pca pc-vectors to take (run both analyses, takes time...)
% each party will have an unique model

%% Weights

w1 = 0.20;
w2 = 1;

% TODO... Gen.Algo?

%% P1 _ (kansanedustaja)

% Kansanedustaja
kansanedustaja = test_data(:,45) > 0;

p1 = w1*kansanedustaja;


%% P2 _ (% size of party in given region) kannatusprosentti

p2 = cell(length(parties), 1);

% TODO... which features indicate this...
% calculate for each region, for each party
% 
% vaalipiirit = 1:14;
% 
% n_total_elected = length(elected);
% 
% for i=vaalipiirit
%     % TODO: TEST IF WORKS
%     
%     elected_idxs = find(data(:,i) >= 0);
%     
% end



%% PC _ Current (somewhat bad) predictions for party membership
% We need the probabilities of candidate belonging to each party
%
% This is a multivariate classification problem
%
% We are using flat prior in classify(...)
%
% TODO: USE NAIVE BAYES

d = 8; % magic number based on k-fold check

target_memberships = party_to_idx_fun(data_target_labels);

% predict_classify classify() order: training, group, sample
[memberships, memberships_posterior] = ...
    predict_classify(data, target_memberships, test_data, d);


%% PX _ Probability of member being chosen based on questions, given party
% We need the probabilities of candidate belonging to each party
%
% This is a binary classification problem
%
% What we could try:
% - mvnpdf
% - nn
% - svm
%
% We remove linear dependencies from the features
% also TODO: do we reduce feature dimensions so
% # samples > # features? Eg. with feature selection or PCA.
%

% not this training_target_labels = party_to_idx_fun(data_target_labels);

pX = cell(length(parties), 1);
pX_projection = cell(length(parties), 1);
pX_explained = cell(length(parties), 1);

for i=1:length(parties)
    
    i
    
    [training_set, removed_col_idxs, saved_col_idxs] = ...
        remove_linear_deps(data_questions(party_members{i},:));
    
    %removed_col_idxs
    %saved_col_idxs
    
    training_target_labels = zeros(length(party_members{i}), 1);
    if isempty(party_members_elected{i})
        elected_idxs = [];
    else
        elected_idxs = find(ismember(party_members{i}, party_members_elected{i}));
    end
    % MEGAFIX: We need two to be elected for normal distribution
    % so ignore those parties where only one is elected
    % and make them just like those where none are elected
    if length(party_members_elected{i}) > 1
        training_target_labels(elected_idxs,:) = 1;
    end
    
    
    sample = test_data_questions(:,saved_col_idxs);
    
    
    % PCA
    deg = 3;
    [coeff, score, ~, ~, explained] = pca(training_set);
    pX_explained{i} = explained;
    pX_projection = coeff(:, 1:deg);
    training_set = score(:, 1:deg);
    sample = sample*coeff(:, 1:deg);
    % end PCA
    
    
    
    whos training_set training_target_labels sample
 
% i = 3:
%  sample                      526x110            462880  double              
%  training_set                 89x110             78320  double              
%  training_target_labels       89x1                 712  double        
    
    nb = NaiveBayes.fit(training_set, training_target_labels);
    pX{i} = posterior(nb, sample);
    
    
    
    % Plot
    figure;
    hold on;

    non_elected_idxs = setdiff(1:length(training_target_labels), elected_idxs)';
    plot3(training_set(non_elected_idxs,1), ...
         training_set(non_elected_idxs,2), ...
         training_set(non_elected_idxs,3), 'r+');
    
    plot3(training_set(elected_idxs,1), ...
         training_set(elected_idxs,2), ...
         training_set(elected_idxs,3), 'g+');
    
    % Hax
    test_training_target_labels = zeros(length(test_party_members{i}), 1);
    if isempty(test_party_members_elected{i})
        test_elected_idxs = [];
    else
        test_elected_idxs = find(ismember(test_party_members{i}, test_party_members_elected{i}));
    end
    plotsample = sample(test_party_members{i},:);
    plot3(plotsample(test_elected_idxs,1), ...
          plotsample(test_elected_idxs,2), ...
          plotsample(test_elected_idxs,3), 'bo');
    % End Hax
    
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    hold off;

    view(3); % show in 3d, since figure is by default 2d
    % end Plot
end

%% P5

p5 = 0;

%for i=1:length(parties)
%    p5 = p5 + memberships + pX{i} + ;
%end



%% Clear

%clear kansanedustaja
%clear coeff score targets_memberships memberships
%clear targets_memberships training_set training_target_labels posterior
%clear sample

