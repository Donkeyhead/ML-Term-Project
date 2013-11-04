

%% Weights

w1 = 0.20;
w2 = 1;

% TODO... Gen.Algo?

%% P1 _ (kansanedustaja)

% Kansanedustaja
kansanedustaja = test_data(:,45) > 0;

p1 = w1*kansanedustaja;


%% P2 _ (% size of party in given region)

p2 = cell(length(parties), 1);

% TODO... which features indicate this...
% calculate for each region, for each party


%% PC _ Current (somewhat bad) predictions for party membership
% flat prior in classify(...)

% using full data
[coeff, score] = pca(data);

d = 8; % magic number based on k-fold check

targets_memberships = party_to_idx_fun(data_target_labels);

memberships = classify(test_data * coeff(:, 1:d), score(:, 1:d), ...
    targets_memberships);


%% PX _ Probability of member being chosen based on questions, given party
% Flat prior in classify(...)

% TODO HOX: HMM JOILLAIN PUOLUEILLA EI OO KETÄÄN VALITTU...

% LEFT HERE: JOSTAIN SYYSTÄ REMOVE LINEAR DEPS -> covariace matrix ...
% edelleen riippuva ja roikkuva
% __POOLED__ covariance matrix...??????????

% not this training_target_labels = party_to_idx_fun(data_target_labels);

pX = cell(length(parties), 1);

for i=1:length(parties)
    
    [training_set, removed_col_idxs, saved_col_idxs] = remove_linear_deps(data_questions(party_members{i},:));
    
    training_target_labels = zeros(length(party_members{i}), 1);
    training_target_labels(party_members_elected{i},:) = 1;
    
    sample = test_data_questions(:,saved_col_idxs);
    
    whos training_set training_target_labels sample
    
    % predict_classify classify() order: training, group, sample
    
    [~, posterior] = predict_classify(training_set, ...
        training_target_labels, sample, 0);
    
    pX{i} = posterior; % posteriors for members in test_data_questions
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

