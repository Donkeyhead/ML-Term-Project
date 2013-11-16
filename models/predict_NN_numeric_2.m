%% Predict with NN model

function [prediction, unmodified] = predict_NN_numeric_2(sample, net, trainingFio)

% GPU
% if sum(strcmp(trainingFio, ...
%         {'trainbfg', 'traincgb', 'traincgf', 'traincgp', 'traingd', ...
%         'traingda', 'traingdm', 'traingdx', 'trainoss', 'trainrp', ...
%         'trainscg'}))
%     
%     samplegpu = nndata2gpu(sample');
%     
%     Ygpu = net(samplegpu, 'useParallel','yes','useGPU','yes', ...
%         'showResources','yes');
%     unmodified = gpu2nndata(Ygpu);
% 
% else % CPU
% 
%     % RUN: matlabpool open 8
%     unmodified = net(sample', 'useParallel','yes');
% 
% end


% RUN: matlabpool open 8
unmodified = net(sample', 'useParallel','yes');

prediction = vec2ind(unmodified);
prediction = prediction';

end
