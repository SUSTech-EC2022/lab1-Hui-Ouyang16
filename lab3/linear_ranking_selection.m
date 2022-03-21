function [prob_list] = linear_ranking_selection (fitness_list,alpha)
if nargin<2
    alpha=0;
end
mu = length(fitness_list);
sortedi = sort(fitness_list); 
rank = nan(1,mu);
for i = 1:mu
    rank(i) = find(sortedi==fitness_list(i))-1;
end
beta = 2 - alpha;
offset = alpha/mu;
coef = (beta-alpha) / (mu-1) / mu;
prob_list = nan(mu,1);
for i = 1:mu
    prob_list(i) = ( coef * rank(i) + offset);
end