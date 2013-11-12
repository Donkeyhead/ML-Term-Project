%% Project work

% First add function for loading the data to path
addpath('code');
addpath('models');
fname = 'data/data_vk_training.csv';
ftest = 'data/data_vk_test_full.csv';

[target_variables, target_names, data, feature_names] = load_HS_vaalikone(fname);
[test_target_variables, test_target_names, test_data, test_feature_names] = load_HS_vaalikone(ftest);

% Count the different amount of different answers for each different
% observation

data_choices = [];
for d = data
    data_choices = [data_choices, count_choices(d)];
end


%%

% First find names of different parties
parties = unique(target_variables(:, 2)); % Cell-array

%%

party_members = cell(length(parties), 1);
party_to_idx = containers.Map(parties, 1:length(parties));

% Loop over parties
for i=1:length(parties)
    % Select all rows that belong to a particular party
    party_members{i} = find(strcmp(target_variables(:, 2), parties{i}));
end


test_party_members = cell(length(parties), 1);

% Loop over parties in test data
for i=1:length(parties)
    % Select all rows that belong to a particular party
    test_party_members{i} = find(strcmp(test_target_variables(:, 2), parties{i}));
end

%% elected for each party

% Select samples (election candidates) by whether they were elected 
elected = find(strcmp(target_variables(:,1), '1'));
not_elected = find(strcmp(target_variables(:,1), '0'));

party_members_elected = cell(length(parties), 1);
party_members_not_elected = cell(length(parties), 1);

for i=1:length(parties)
    party_members_elected{i} = intersect(party_members{i}, elected);
    party_members_not_elected{i} = intersect(party_members{i}, not_elected);
end

% Select samples (election candidates) by whether they were elected 
test_elected = find(strcmp(test_target_variables(:,1), '1'));
test_not_elected = find(strcmp(test_target_variables(:,1), '0'));

test_party_members_elected = cell(length(parties), 1);
test_party_members_not_elected = cell(length(parties), 1);

for i=1:length(parties)
    test_party_members_elected{i} = intersect(test_party_members{i}, test_elected);
    test_party_members_not_elected{i} = intersect(test_party_members{i}, test_not_elected);
end

% Calculate mean and variance of the candidates ages

party_members_age_mean = [1:length(parties)];
party_members_age_variance = [1:length(parties)];
for i=1:length(parties)
    party_members_age_mean(i) = mean(data(party_members{i}, 42));
    party_members_age_variance(i) = var(data(party_members{i}, 42));
end

%% partition data

% z = find(cellfun(@iscomment, feature_names))

idx_misc = [1:48 , 170:171];
idx_questions = 49:169;
idx_comments = 172:199;

% training
% --------

% only misc stuff
feature_misc = feature_names(idx_misc);
% only questions
feature_questions = feature_names(idx_questions);
% only comments
feature_comments = feature_names(idx_comments);

data_misc = data(:, idx_misc);
data_questions = data(:, idx_questions);
data_comments = data(:, idx_comments);

% test
% ----

test_data_misc = test_data(:, idx_misc);
test_data_questions = test_data(:, idx_questions);
test_data_comments = test_data(:, idx_comments);

%% Some renaming for convenience

data_target_labels = target_variables(:,2);
test_data_target_labels = test_target_variables(:,2);

party_specific_labels = zeros(size(data_target_labels, 1), size(parties,1));
for p = 1:size(parties,1)
    party_specific_labels(party_members{p}, p) = 1;
end

test_party_specific_labels = zeros(size(test_data_target_labels, 1), size(parties,1));
for p = 1:size(parties,1)
    test_party_specific_labels(test_party_members{p}, p) = 1;
end

data_target_elected = str2double(target_variables(:,1));
test_data_target_elected = str2double(test_target_variables(:,1));

%% Data descriptive values

%Calculate maximum values

dataN = size(data, 1);

partiesN = cellfun(@(x) size(x, 1), party_members);
partiesP = partiesN./dataN;

min_data = min(data);
min_misc = min_data(idx_misc);
min_questions = min_data(idx_questions);
min_comments = min_data(idx_comments);

max_data = max(data);
max_misc = max_data(idx_misc);
max_questions = max_data(idx_questions);
max_comments = max_data(idx_comments);

%Calculate data correlations

data_correlation = corr(data);
data_questions_correlation = corr(data_questions);

party_members_correlations = cell(length(parties), 1);
for i=1:length(parties)
    party_members_correlations{i} = corr(data_questions(party_members{i}, :));
    %subplot(5,4,i);
    %imagesc(party_members_correlations{i});
end

% Calculate data covariances

data_covariance = cov(data);
data_questions_covariance = cov(data_questions);

party_members_covariances = cell(length(parties), 1);
for i=1:length(parties)
    % Cheat by renormalizing without knowing if this is even right
    party_members_covariances{i} = cov(zscore(data_questions(party_members{i}, :)));
    %subplot(5,4,i);
    %imagesc(party_members_covariances{i});
end
    
% Calculate data means

data_means = mean(data);
data_questions_means = mean(data_questions);

party_members_means = cell(length(parties), 1);
for i=1:length(parties)
    party_members_means{i} = mean(data_questions(party_members{i}, :));
    %subplot(5,4,i);
    %imagesc(party_members_means{i});
end
c{1} = 1;
attributes_grouped = group_questions(c, data, min_data, 1, 2);
clear c;

% Calculate the amount of current members that are congressmen

party_members_congressmen = [1:length(parties)];
for i=1:length(parties)
    party_members_congressmen(i) = size(find(data(party_members{i},45) == ...
    max_data(45)), 1) / size(party_members{i}, 1);
end
