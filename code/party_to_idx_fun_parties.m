function ret = party_to_idx_fun_parties(data, parties2)

party_to_idx2 = containers.Map(parties2, 1:length(parties2));

ret = cellfun(@(x) party_to_idx2(x), data);

end