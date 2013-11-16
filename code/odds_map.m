function [odds_mapped] = odds_map(data)
%ODDS_MAP Summary of this function goes here
    odds_mapped = cell(1, size(data, 2));
    for i = 1:size(data,2)
       vals = unique(data(:,i));
       odds = arrayfun(@(x) size(find(data(:,i) == x), 1)/size(data,1), vals);
       odds_mapped{i} = containers.Map(vals, odds);
    end
end