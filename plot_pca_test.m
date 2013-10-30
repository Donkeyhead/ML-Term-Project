
%% Calculate PCA for questions

[coeff,score,latent,tsquared,explained] = pca(data_questions);


%% Plot 3d with three first vectors

figure();
hold on;

cmap = hsv(length(parties)) % colormap

for i=1:length(parties)
    %data_questions(party_members{i},:);
    score1 = score(party_members{i},1);
    score2 = score(party_members{i},2);
    score3 = score(party_members{i},3);
    plot3(score1, score2, score3, '+', 'Color',cmap(i,:))
end

clear score1 score2 score3 cmap

hold off;

view(3); % show in 3d, since figure is by default 2d
