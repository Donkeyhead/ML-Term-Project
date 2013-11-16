function [data_odds] = calc_data_odds(data)
%CALC_DATA_ODDS Replaces each data with the odds of such data
    data_odds = zeros(size(data, 1), size(data, 2));
    for d = 1:size(data,2)
        vals = unique(data(:,d));
        val_idx = cell(1,size(vals,1));
        for i = 1:size(vals,1)
            val_idx{i} = find(data(:,d) == vals(i));
        end
        choice_to_odds = containers.Map(vals, cellfun(@(x) size(x,1),val_idx)./size(data,1));
        data_odds(:, d) = arrayfun(@(x) choice_to_odds(x), data(:,d));
    end
end

