% MLPB 2013 term project classification evaluation
%
% Data: election candidates
%
% Classification task:
% a. predict election result per candidate, 1=elected, 0=not elected
% b. predict (determine) candidate's party, several classes, denoted by
% 1,2,3 ..
%
%
% This file contains the evaluation function for the prediction task
%
% NOTE: 0/0 = 0 in the metrics.
% For multiclass, we return both the average of per-class binary-scores and 
% scores per average confusion matrix.
%

%' Evaluation metrics for predicted and test labels. Generic.
%'
%' parameters:
%' prediction Table of predictions, named data.frame
%' truth Table of true labels, same dimensions as prediction
%' 
function [results]=evaluate(prediction,truth)
  % check dims
  %if (sum(size(prediction)==size(truth))==2),error('myApp:DimensionCheck', 'shape mismatch, prediction and truth.'); end
  % check colnames
  %if(!all(colnames(prediction) == colnames(truth)))
  %  stop("Variable mismatch, prediction and truth.")
  %end
  %
  %varnames = colnames(prediction);
  %
  results = cell(size(truth,2),3);
  % loop over variables (columns)
  for v=1:size(truth,2) 
    vals_pred = prediction(:,v);
    vals_truth = truth(:,v);
    % make sure we're dealing with factors
    % if(is.factor(vals_pred)), vals_pred = vals_pred; else vals_pred = factor(vals_pred); end
    % if(is.factor(vals_truth)), vals_truth = vals_truth; else vals_truth = factor(vals_truth); end
    % check levels match
    levs_pred = unique(vals_pred);levs_truth = unique(vals_truth);
    %if(!all(levs_pred == levs_truth)) stop("Level mismatch in column ", v)
    nlevels = length(levs_pred);
    % confusion matrix
    A = crosstab(vals_pred, vals_truth);
    % Used format for binary classification:
    %  TN, FN
    %  FP, TP
    %
    % If only binary classification
    if(nlevels == 2) 
      result = evaluate_binary(A);
      rownames = cell(length(levs_truth),1);for ind = 1:length(levs_truth), rownames{ind} = num2str(levs_truth(ind)); end
    else
      % multi-label. We average over binary classifications
      result = zeros(nlevels,6); Bave = zeros(2,2);
      for l=1:nlevels
        % level l confusion matrix
        tp = A(l,l);
        tn = sum(sum(A([1:l-1,l+1:end],[1:l-1,l+1:end])));
        fp = sum(sum(A(l,[1:l-1,l+1:end])));
        fn = sum(sum(A([1:l-1,l+1:end],l)));
        B = [tn,fn;fp,tp];
        Bave = Bave + B;
        result(l,:) = evaluate_binary(B);
      end
      % average over the classes. Using average confusion matrix
      ave_result = evaluate_binary(Bave / nlevels);
      % and value averages
      result = [mean(result); ave_result; result];
      rownames = cell(2+length(levs_truth),1);rownames{1}='score_mean';rownames{2}='confusion_mean';
      for ind = 3:2+length(levs_truth), rownames{ind} = num2str(levs_truth(ind-2)); end
    end
    colnames=['Fscore','phi_score','accuracy','false_pos_rate','sensitivity','pos_pred_value'];
    results{v,1}=rownames;
    results{v,2}=result; 
    results{v,3}=colnames;
  end
  % done.
%%%%%%%%%%
function [result]=evaluate_binary(A)
  % see http://en.wikipedia.org/wiki/Sensitivity_and_specificity%Worked_example
  if(sum(A(2,:))), pos_pred_value = A(2,2)/sum(A(2,:));  else pos_pred_value = 0;   end% same as precision
  sensitivity = A(2,2)/sum(A(:,2)); % same as recall
  accuracy = (A(1,1)+A(2,2))/sum(sum(A));
  false_pos_rate = A(2,1)/(A(2,1)+A(1,1));
  Fscore = 2 * (pos_pred_value*sensitivity)/(pos_pred_value + sensitivity);
  if(isnan(Fscore)),  Fscore = 0; end % we decided this.
  % phi score aka Matthews correlation coefficient
  denom = sqrt(sum(A,1)*sum(A,2));
  if(denom), phi_score = (A(2,2)*A(1,1) - A(1,2)*A(2,1))/denom; else phi_score = 0; end
  % keep all
  result=[Fscore,phi_score,accuracy,false_pos_rate,sensitivity,pos_pred_value];
%%%%%%%%%%%%%%%%%%%




