function new_data = reduce_dimensions(data, data_groups)
    counter = 1;
    new_data = [];
    for i = 1:size(data_groups,2)
        [~, score, ~, ~, explained] = pca(data(:,data_groups{i}));
        meaningful = 1;
        last = 0;
        for j = 1:size(explained, 1)
            new = sum(explained(1:j));
            if (new - last > 5)
                meaningful = j;
            end
            last = new;
        end
        new_data(:,counter:counter+meaningful - 1) = score(:,1:meaningful);
        counter = counter + meaningful;
    end
end
