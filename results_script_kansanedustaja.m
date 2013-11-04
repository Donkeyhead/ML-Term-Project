
% ELECTED OR NOT ELECTED
% predict by Kansanedustaja

data_load_script;

predIs = test_data(:,45) > 0;

results = evaluate_2(predIs, test_data_target_elected);

results{2}
