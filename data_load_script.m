%% Project work

% First add function for loading the data to path
addpath('code');
fname = 'data/data_vk_training.csv';

[target_variables, target_names, data, feature_names] = load_HS_vaalikone(fname);

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

%% partition data

% z = find(cellfun(@iscomment, feature_names))

idx_misc = [1:48 , 170:171];
idx_questions = 49:169;
idx_comments = 172:199;

% only misc stuff
feature_misc = feature_names(idx_misc);
% only questions
feature_questions = feature_names(idx_questions);
% only comments
feature_comments = feature_names(idx_comments);

data_misc = data(:, idx_misc);
data_questions = data(:, idx_questions);
data_comments = data(:, idx_comments);

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
    party_members_covariances{i} = cov(data_questions(party_members{i}, :));
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

