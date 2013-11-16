%X = randn(300,18);
%Y = X*randn(18,1) > 4; % use your data instead
X = data_questions;
Y = data_target_labels;
Y = party_to_idx_fun(Y);

classnames = 1:17;

%Y = data_target_elected;
%classnames = [0,1];
cost=[0 100 ; 1 0]; % think seriously about these values. 100 is cost classifying a positive sample as negative and 10 the cost of the other error.

MinLeaf=length(Y)/2; %determines the individual tree size. the higher, the smaller are the trees. length(Y)/2 means only one split.
nTrees=200;

% party:
ens = fitensemble(X, Y, 'AdaBoostM2',nTrees,ClassificationTree.template('MinLeaf',MinLeaf),'nprint',1,'crossval','on','k',5,'classnames',classnames);
% elected:
%ens = fitensemble(X, Y, 'AdaBoostM1',nTrees,ClassificationTree.template('MinLeaf',MinLeaf),'nprint',1,'crossval','on','k',5,'cost',cost,'classnames',classnames);
% orig:
%ens = fitensemble(X, Y, 'AdaBoostM1',nTrees,ClassificationTree.template('MinLeaf',MinLeaf),'nprint',1,'crossval','on','k',5,'cost',cost,'classnames',[true, false]);
%figure;
for i=1:ens.KFold
  cumlossTrain(1:ens.NTrainedPerFold(i),i)=loss(ens.Trainable{i},ens.X(ens.Partition.training(i),:),ens.Y(ens.Partition.training(i)),'mode','cumulative');
  lossTrain(1,i)=loss(ens.Trainable{i},ens.X(ens.Partition.training(i),:),ens.Y(ens.Partition.training(i)));

  cumlossCV(1:ens.NTrainedPerFold(i),i)=loss(ens.Trainable{i},ens.X(ens.Partition.test(i),:),ens.Y(ens.Partition.test(i)),'mode','cumulative');
  lossCV(1,i)=loss(ens.Trainable{i},ens.X(ens.Partition.test(i),:),ens.Y(ens.Partition.test(i)));
  %scatter(1:1:ens.NTrainedPerFold(i),cumlossTrain(:,i),'r');
  %hold on;hold all;
  %scatter(1:1:ens.NTrainedPerFold(i),cumlossCV(:,i),'b');
  cumlossTrain(:,i)
  cumlossCV(i)
end