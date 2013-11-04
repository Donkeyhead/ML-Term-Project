%% There be dragons Combinator

function prediction = tbd_combinator(predictions, fscores)

prediction = NaN;
maxF = 0;

for i=unique(predictions)
    idx = find(predictions == i);
    fsum = sum(fscores(idx))/length(idx);
    if fsum > maxF
        maxF = fsum;
        prediction = i;
    end
end

end
