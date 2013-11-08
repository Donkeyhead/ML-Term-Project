function new_data = reduce_dimensions(data, data_groups)
    
    new_data = zeros(size(data,1), size(data_groups,2));
    for i = 1:size(data_groups,2)
        [~, score] = pca(data(:,data_groups{i}));
        new_data(:,i) = score(:,1);
    end
end
