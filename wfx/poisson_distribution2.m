close all;
clc;
% Workshop Purposes: For a binomial distribution needs p and q values
p = 0.6; % success of trial
q = 1 - p; % failure of trial
%
n = 30; % the total number of trials
k = 0:n; % the trial number
lambda = 11;

prob_dist = poisspdf(lambda,k);
figure(3);
plot(k,prob_dist);
hold on;
for i = 1:10
ktest = round(n*rand(1));
p_test=poisspdf(lambda,ktest);
q_test=rand(1);
if p_test >=q_test
    prob_test = poisspdf(lambda,ktest);
    plot(ktest,prob_test,'ro');
end
end
hold off;

title('possion distribution');
xlabel('number of release'); ylabel('possibility');