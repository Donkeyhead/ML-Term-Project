%% Project work

% First add function for loading the data to path
addpath('code')
fname = 'data/data_vk_training.csv';

[target_variables, target_names, data, feature_names] = load_HS_vaalikone(fname);

%% see what we have
% Output workspace
whos

% Names of variables
feature_names{:}

% Select samples (election candidates) by whether they were elected 
elected = find(strcmp(target_variables(:,1), '1'));
not_elected = find(strcmp(target_variables(:,1), '0'));

% Plot correlations between variables
imagesc(corr(data));
% Plot correlations between candidates
imagesc(corr(data'));

% Compare to correlations in random data
imagesc(corr(rand(size(data'))));

% Correlation between first 20 variables and candidate being elected
corr(data(:, 1:20), strcmp(target_variables(:, 1), '1'))

% Sort by party
% First find names of different parties
parties = unique(target_variables(:, 2)); % Cell-array

% Numerical indexes that we use to resort the matrix
indexes = [];

% Loop over parties
for i=1:length(parties)
    % Select all rows that belong to a particular party
    indexes = [indexes; find(strcmp(target_variables(:, 2), parties{i}))];
end
% Resort in the order of parties
sorted_data = data(indexes, :);

imagesc(sorted_data)

% Compare to data sorted by whether candidate was elected
imagesc(data([elected; not_elected], :))
