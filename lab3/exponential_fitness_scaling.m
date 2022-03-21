function [exponential_fitness_list] = exponential_fitness_scaling (fitness_list, T)
if nargin<2
    T = 0.1;
end
mu = length(fitness_list);
exponential_fitness_list = nan(mu,1);
for i = 1:mu
    exponential_fitness_list(i) = exp(fitness_list(i/T);
end
