for i = 1:size(data, 2)
    attr = data(:, i);
    i
    plot(1:size(attr,1), attr, 'ro');
    pause
end


