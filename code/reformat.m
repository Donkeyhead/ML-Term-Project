function [new_data] = reformat(data)
    new_data = zeros(size(data, 1), size(data, 2));
    for d = 1:size(data,2)
        vals = unique(data(:,d));
        new_data(:, d) = arrayfun(@(x) find(vals == x), data(:,d));
    end

end

