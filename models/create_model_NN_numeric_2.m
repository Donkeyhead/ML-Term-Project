
%% A neural network approach
% 2 layer perceptron

function [net, tr] = create_model_NN_numeric_2(data, data_labels, numLayers, trainingFio)

nn_data = data';
nn_targets = full(ind2vec(data_labels'));

%whos nn_data
%whos nn_targets
%nn_targets


net = patternnet(10, trainingFio);
net.numLayers = numLayers;
net.trainParam.showWindow = 0;



% GPU
if sum(strcmp(trainingFio, ...
        {'trainbfg', 'traincgb', 'traincgf', 'traincgp', 'traingd', ...
        'traingda', 'traingdm', 'traingdx', 'trainoss', 'trainrp', ...
        'trainscg'}))
    %Xgpu = nndata2gpu(nn_data);
    %Tgpu = nndata2gpu(nn_targets);
    
    %whos nn_data nn_targets Xgpu Tgpu
    
    [net, tr] = train(net, nn_data, nn_targets, ...
        'useParallel','yes','useGPU','yes','showResources','yes');

else % CPU

    % RUN: matlabpool open 8
    [net, tr] = train(net, nn_data, nn_targets, ...
        'useParallel','yes','showResources','yes');

end

%view(net)


end
