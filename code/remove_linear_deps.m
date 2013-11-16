% ML Project s2013 - vukk
% Also removes constant features (columns) ie. those with Var=0
function [data_out, removed_col_idxs, saved_col_idxs] = remove_linear_deps(data)
    %% Remove linearly dependent columns, leaving only one
    
    [~, licols] = rref(data);
    
    %% Remove columns with var=0 (constant features)
    
    %% NaNs
    removed = setdiff(1:size(data, 2), licols);
    
    cc = corrcoef(data);
    
    %removed = sort([removed, find(isnan(cc(1,:)) == 1)]);
    removed = sort([removed, find(all(isnan(cc) == 1))]);
    removed = unique(removed);
    
    
    %% Near Zeros
    
    saved_col_idxs = setdiff(1:size(data, 2), removed);
    
    cc2 = corrcoef(data(:,saved_col_idxs));
    
    nearzero = find(sum(abs(cc2))-1 < 1e-6);
    removed = sort([removed, saved_col_idxs(nearzero)]);
    removed = unique(removed);
    
    
    %% Return stuff
    
    saved_col_idxs = setdiff(1:size(data, 2), removed);
    removed_col_idxs = removed;
    
    %whos data save_col_idxs removed dont_remove
    
    data_out = data(:,saved_col_idxs);
end


