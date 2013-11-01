
% wrapper
function [results]=evaluateCellParties(prediction,truth, parties2)


p = party_to_idx_fun_parties(prediction, parties2);
t = party_to_idx_fun_parties(truth, parties2);

results = evaluate(p, t);

end