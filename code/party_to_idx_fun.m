
function ret = party_to_idx_fun(data)

parties = {'IPU'; 'KA'; 'KD'; 'KESK'; 'KOK'; 'KTP'; 'M2011'; 'PIR'; 'PS'; 'RKP'; 'SDP'; 'SEN'; 'SKP'; 'STP'; 'VAS'; 'VIHR'; 'VP'};

party_to_idx = containers.Map(parties, 1:length(parties));

ret = cellfun(@(x) party_to_idx(x), data);


end