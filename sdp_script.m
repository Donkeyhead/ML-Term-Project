
%% SDP SCRIPT

bin_prediction = cell(length(parties), 1);

for i = 1:length(parties)

i

used_data = data_questions;
used_test_data = test_data_questions;
%chosen_party = 'KA';
chosen_party = parties{i};

%sdp_idxs = party_members{party_to_idx(chosen_party)};
%sdp = used_data(sdp_idxs, :);

%non_sdp_idxs = setdiff(1:length(data), party_members{party_to_idx(chosen_party)});
%non_sdp = used_data(non_sdp_idxs, :);

%test_sdp_idxs = test_party_members{party_to_idx(chosen_party)};
%test_non_sdp_idxs = setdiff(1:length(test_data), test_party_members{party_to_idx(chosen_party)});

%labels = zeros(length(used_data), 1);
%labels(sdp_idxs) = 1;

labels = party_specific_labels(:,party_to_idx(chosen_party));
test_labels = test_party_specific_labels(:,party_to_idx(chosen_party));
% to 1 and 2 instead of 0 and 1
labels = labels + 1;
test_labels = test_labels + 1;

%test_labels = zeros(length(used_test_data), 1);
%test_labels(test_sdp_idxs) = 1;

sdp_parties = {'Other' ; 'Party'};
%sdp_parties = containers.Map(1:length(sdp_parties), sdp_parties);

%% Train
[net, tr] = create_model_NN_numeric(data_questions, labels, 2);
[pred, unmod] = predict_NN_numeric(test_data_questions, net);
%res= evaluateCellParties(pred, sdp_parties(test_labels), sdp_parties);
%whos pred test_labels
res = evaluate_2(pred, test_labels);
[confus,numcorrect,precision,recall,F] = getcm(test_labels,pred,[1:2]');
pred = pred - 1;

%% Output
res{2}
F

bin_prediction{i} = pred;

end

clear i labels test_labels

%
% P_SDP = pred
% P_KOK = pred
%intersect(find(party_to_idx_fun_parties(P_KOK, sdp_parties) == 2), find(party_to_idx_fun_parties(P_SDP, sdp_parties) == 2))

% base priori = ennusta aina suurin puolue kun conflict
