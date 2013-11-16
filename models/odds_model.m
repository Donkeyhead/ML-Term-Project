function [mHandle, elec_odds] = odds_model(data, elec, parties)
% Creates the model based on training data
    
    elec_maps = cell(1,size(elec,1));
    for i = 1:size(elec,1)
        elec_maps{i} = odds_map(data(elec{i},:));
    end
    
    party_maps = cell(1,size(parties,1));
    for i = 1:size(parties)
        party_maps{i} = odds_map(data(parties{i},:));
    end
    
    mHandle = @model;

    function [pred, elec_odds]  = model(d, w)
        pred = zeros(2,size(d,1));
        elec_odds = zeros(2,size(d,1));
        %party_odds = zeros(size(d,1), 1:size(parties,1));
        for i = 1:2
            odds_matrix = ones(size(d,1), size(d,2));
            elec_map = elec_maps{i};
            for j = 1:size(d,2)
                map = elec_map{j};
                for k = 1:size(d,1)
                    disp('Val: ') 
                    disp(d(k,j))
                    if isKey(map, d(k,j))
                        disp('Odds: ')
                        disp(map(d(k,j)))
                        odds_matrix(k,j) = map(d(k,j));
                    else
                        odds_matrix(k,j) = w;
                    end
                end
            end
            elec_odds(i,:) = prod(odds_matrix');
        end
        pred(1,:) = elec_odds(1,:) > elec_odds(2,:);
        
        %for i = 1:2
        %    odds_matrix = ones(size(d,1), size(d,2));
        %    party_map = party_maps{i};
        %    for j = 1:size(d,2)
        %        odds_matrix(:,j) = arrayfun(@(x) party_map(x), d(:,j)); 
        %    end
        %    party_odds(i) = sum_odds(matrix);
        %end
    end
end

