function [prob_list] = rank_based_selection (fitness_list)
mu = length(fitness_list);
sortedi = sort(fitness_list); 
rank = nan(1,mu);
for i = 1:mu
    rank(i) = find(sortedi==fitness_list(i))-1;
end
prob_list = nan(mu,1);
sum_rank = sum(rank) + mu;
for i = 1:mu
    prob_list(i) = (rank(i)+1)/sum_rank;
end
end

