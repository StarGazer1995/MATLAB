close all;
clc;
% Workshop Purposes: For a binomial distribution needs p and q values
p = 0.6; % success of trial
q = 1 - p; % failure of trial
%
n = 30; % the total number of trials
k = 0:n; % the trial number
lambda = 11;
%
prob_dist = poisspdf(lambda,k);
figure(3);
plot(k,prob_dist);

title('possion distribution');
xlabel('number of release'); ylabel('possibility');