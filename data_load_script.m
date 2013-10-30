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
