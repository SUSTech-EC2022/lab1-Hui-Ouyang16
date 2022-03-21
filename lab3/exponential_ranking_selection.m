function [prob_list] = exponential_ranking_selection (fitness_list)
mu = length(fitness_list);
sortedi = sort(fitness_list); 
rank = nan(1,mu);
for i = 1:mu
    rank(i) = find(sortedi==fitness_list(i))-1;
end
C = mu - ( exp(1) - exp(1-mu) ) / ( exp(1) -1 );
prob_list = nan(mu,1);
for i = 1:mu
    prob_list(i) = ( ( 1 - exp(-rank(i))) / C );
end

