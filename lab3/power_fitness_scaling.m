function [power_fitness_list] = power_fitness_scaling (fitness_list, pow)
if nargin<2
    pow = 1;
end
mu = length(fitness_list);
power_fitness_list = nan(mu,1);
for i = 1:mu
    power_fitness_list(i) = (power(fitness_list(i, pow));
end
