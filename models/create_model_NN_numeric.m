
%% A neural network approach
% 2 layer perceptron

function [net, tr] = create_model_NN_numeric(data, data_labels, numLayers)

nn_data = data';
nn_targets = full(ind2vec(data_labels'));

net = patternnet(10);
net.numLayers = numLayers;
[net, tr] = train(net, nn_data, nn_targets);

%view(net)


end
