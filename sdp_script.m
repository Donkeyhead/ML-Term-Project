
%% SDP SCRIPT

used_data = data_questions;
used_test_data = test_data_questions;
chosen_party = 'VAS';

sdp_idxs = party_members{party_to_idx(chosen_party)};
sdp = used_data(sdp_idxs, :);

non_sdp_idxs = setdiff(1:length(data), party_members{party_to_idx(chosen_party)});
non_sdp = used_data(non_sdp_idxs, :);

test_sdp_idxs = test_party_members{party_to_idx(chosen_party)};
test_non_sdp_idxs = setdiff(1:length(test_data), test_party_members{party_to_idx(chosen_party)});

labels = ones(length(used_data), 1);
labels(sdp_idxs) = 2;

test_labels = ones(length(used_test_data), 1);
test_labels(test_sdp_idxs) = 2;

sdp_parties = {'Other' ; 'Party'};

%% Train
[net, tr] = create_model_NN_numeric(data_questions, labels, 2);
[pred, unmod] = predict_NN(test_data_questions, net, sdp_parties);
res= evaluateCellParties(pred, sdp_parties(test_labels), sdp_parties);

%% Output
res{2}

%
% P_SDP = pred
% P_KOK = pred
%intersect(find(party_to_idx_fun_parties(P_KOK, sdp_parties) == 2), find(party_to_idx_fun_parties(P_SDP, sdp_parties) == 2))

% base priori = ennusta aina suurin puolue kun conflict
