%% Predict with NN model

function [prediction, unmodified] = predict_NN(sample, net, parties)

unmodified = net(sample');
prediction = parties(vec2ind(unmodified));

end
