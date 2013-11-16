classes = parties;

training_labels = party_to_idx_fun(data_target_labels);
test_labels = party_to_idx_fun(test_data_target_labels);
model = create_pca_classify_model(data, training_labels);

s = 200;

fscores = [];
for i = 1:s
    pred = model(test_data, 0.5 + i/s);
    r = evaluate_2(pred, test_labels);
    r = r{2};
    fscores = [fscores, r(1,1)];
end
plot([1:s]./s, fscores, 'rx')