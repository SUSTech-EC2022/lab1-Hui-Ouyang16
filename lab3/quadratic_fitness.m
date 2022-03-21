function [fitness] = quadratic_fitness(x)
fitness = sum(x.^2,2);
end

