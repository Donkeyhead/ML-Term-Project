
% wrapper
function [results]=evaluateCell(prediction,truth)


p = party_to_idx_fun(prediction);
t = party_to_idx_fun(truth);

results = evaluate(p, t);

end