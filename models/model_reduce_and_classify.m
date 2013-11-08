clear all

data_load_script

d = data_reduced;

test_data_reduced = reduce_dimensions(test_data, attributes_grouped);

p = classify(test_data_reduced, data_reduced, data_target_labels);

pred = cellfun(@(x) party_to_idx(x), p);
tl = cellfun(@(x) party_to_idx(x), test_data_target_labels);

r = evaluate(pred,tl);
