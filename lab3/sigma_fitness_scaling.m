function [sigma_fitness_list] = sigma_fitness_scaling (fitness_list, c)
if nargin<2
    c = 1;
end
offset = mean(fitness_list) - ( c * std(fitness_list) );
mu = length(fitness_list);
sigma_fitness_list = nan(mu,1);
for i = 1:mu
    sigma_fitness_list(i) = (max(fitness_list(i) - offset, 0));
end
