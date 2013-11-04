% ML Project s2013 - vukk
function [data_out, removed_col_idxs, saved_col_idxs] = remove_linear_deps(data)
    cc = corrcoef(data);
    % find x,y pairs where there are linear dependencies
    % within machine precision eps
    % abs so that we catch -1:s at the same time
    [row, col] = find(abs(cc) > 1-eps);
    % forget about those ones that are in the diagonal
    % a variable is ofc, linearly dependent of itself
    lin_dep_idxs = find(row - col ~= 0);
    
    % prefers removing later columns to removing earlier ones...
    
    dont_remove = [NaN]; % can't prealloc?
    removed = [NaN];
    % we might be able to vectorize everything though...
    
    %whos row col lin_dep_idxs
    
    saveIdx = 1;
    remIdx = 1;
    for i=lin_dep_idxs'
        %fprintf('r: %d c: %d\n', row(i), col(i));
        %[row(i), col(i)]
        if any(col(i) == dont_remove)
            % col(i) flagged as the one "to be saved"
            if any(row(i) ~= removed)
                %fprintf('col %d flagged, removing row %d\n', col(i), row(i));
                % row(i) not removed yet, so remove
                removed(remIdx) = row(i);
                remIdx = remIdx + 1;
            end
            % else: row(i) already removed, so continue
            %fprintf('col %d flagged, row %d removed, continue\n', col(i), row(i));
            continue
        end
        
        % else: col(i) not flagged as "to be saved"
        if any(col(i) == removed)
            %fprintf('col %d removed, continue\n', col(i));
            continue % dependency removed or will be removed by code above
        end
        
        % else: col(i) not flagged as "to be saved",
        %       col(i) not flagged as removed
        
        if any(row(i) == dont_remove)
            %fprintf('row %d flagged, continue\n', row(i));
            continue % don't remove the one flagged "to be saved"
        end
        
        % else: col(i) not flagged as "to be saved",
        %       col(i) not flagged as removed
        %       row(i) not flagged as "to be saved"
        
        if any( 1 - (row(i) == removed) ) % not in removed
            %fprintf('flagging col %d, removing row %d\n', col(i), row(i));
            % row(i) not removed yet, so flag col(i) and remove row(i)
            % flag col(i) "to be saved"
            dont_remove(saveIdx) = col(i);
            saveIdx = saveIdx + 1;
            % remove row(i)
            removed(remIdx) = row(i);
            remIdx = remIdx + 1;
        else
            %fprintf('nothing fits\n');
        end
    end
    
    saved_col_idxs = setdiff(1:size(data, 2), removed);
    removed_col_idxs = removed;
    %whos data save_col_idxs removed dont_remove
    data_out = data(:,saved_col_idxs);
end


