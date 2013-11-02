function g = group_questions(group, data, min_data, k, i)
    if (i < size(data, 2) + 1)
        in_group = [];
        indxer = group{k};
        for indx = indxer'
            items = find(data(:,indx) ~= min_data(indx));
            in_group = cat(1, in_group, items);
        end
        suspect = find(data(:,i) ~= min_data(i));
        if (isempty(intersect(in_group, suspect)))
            group{k} = cat(1,group{k},i);
            g = group_questions(group, data, min_data, k, i + 1);
        else
            group{k+1} = i;
            g = group_questions(group,data, min_data, k + 1,i + 1);
        end
    else
        g = group;
    end
end
