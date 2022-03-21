function [scaled_fitness_list] = simple_fitness_scaling (fitness_list)
mu = length(fitness_list);
worst_fitness = min(fitness_list);
scaled_fitness_list = nan(mu,1);
for i = 1:mu
    scaled_fitness_list(i) = (fitness_list(i) - worst_fitness);
end
