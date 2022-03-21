function [prob_list] = roulette_wheel_selection( fitness_list ) 
mu = length(fitness_list);
sum_fitness = sum(fitness_list);
prob_list = nan(mu,1);
for i = 1:mu
    prob_list(i) = fitness_list(i)/sum_fitness;
end
end

