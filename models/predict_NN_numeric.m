%% Predict with NN model

function [prediction, unmodified] = predict_NN_numeric(sample, net)

unmodified = net(sample');
prediction = vec2ind(unmodified);
prediction = prediction';

end
