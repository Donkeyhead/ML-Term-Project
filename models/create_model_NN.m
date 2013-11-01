
%% A neural network approach
% 2 layer perceptron

function [net, tr] = create_model_NN(data, data_labels, party_to_idx)

nn_data = data';
nn_tmp = cellfun(@(x) party_to_idx(x), data_labels);
nn_targets = full(ind2vec(nn_tmp'));

net = patternnet(10);
[net, tr] = train(net, nn_data, nn_targets);

%view(net)


end
