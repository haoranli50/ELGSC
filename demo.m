clear
clc
addpath(genpath('.'))
%% load dataset
data_set = 'jaffe.mat';
load(data_set)
%% set parameter
alpha = 100; %fix
beta = 1;
gamma = 1e-4;
anchor = 2;
repeate = 2;
%% get relatex var
cluster_num = length(unique(Y));
sample_num = length(Y);
%% Automatically fit data (row, column vector)
if(size(Y,2)~=1)
    Y = Y';
end
if ~isempty(find(Y==0,1))
    Y = Y + 1;
end
if size(X,2)~=sample_num
    X = X';
end
X = NormalizeFea(X,0);
%% clustering
res = zeros(repeate,10);
for retry = 1:repeate
    tic;
    [C,Z, obj, ~] = ELGSC(X,alpha,beta,gamma,cluster_num*anchor);
    t = toc;
    results = clustering8(Z,cluster_num,Y);
    res(retry,:) = [retry,results,t];
end
%% output
mean_res = mean(res(:,2:10),1);
std_res = std(res(:,2:10),0,1);
fprintf('@ [dataset:%s] @ \n', data_set);
fprintf('@ Fscore:%3.4f(%3.4f) / Precision:%3.4f(%3.4f) / Recall:%3.4f(%3.4f) / MIhat:%3.4f(%3.4f) / AR:%3.4f(%3.4f) / Entropy:%3.4f(%3.4f) / ACC:%3.4f(%3.4f) / Purity:%3.4f(%3.4f) / Time:%6.2f(%6.2f) \n', mean_res(1),std_res(1),mean_res(2),std_res(2),mean_res(3),std_res(3),mean_res(4),std_res(4),mean_res(5),std_res(5),mean_res(6),std_res(6),mean_res(7),std_res(7),mean_res(8),std_res(8),mean_res(9),std_res(9));
fprintf('Finish...\n');