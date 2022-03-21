function [sliding_window_fitness_list] = fitness_scaling_sliding_window (fitness_list, worst_fitness_sliding_window)
mu = length(fitness_list);
sliding_window_fitness_list = nan(mu,1);
for i = 1:mu
    sliding_window_fitness_list(i) = (fitness_list(i) -  worst_fitness_sliding_window);
end
