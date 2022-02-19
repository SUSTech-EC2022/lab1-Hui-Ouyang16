function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
  warning(['Objective function not specified, ''' objFunc ''' used']);
  fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
  error('Argument FITFUNC must be a string');
end
if isempty(T)
  warning(['Budget not specified. 1000000 used']);
  T = '1000000';
end
eval(sprintf('objective=@%s;',fitFunc));
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population 
%% Below starting your code

% Initialise a population
% popsize = 4;
popsize = 10;
lb = 0;
ub = 31;
bin_len = 5;
pop_dec = randi([lb, ub], popsize, 1);
pop_bin = dec2bin(pop_dec);

% Evaluate the initial population
pop_fitness = objective(pop_dec);
[pop_fitness_sorted, pop_index_sorted] = sort(pop_fitness, 1, 'descend');
fitness_pop = [fitness_pop, pop_fitness_sorted(1)];
if pop_fitness_sorted(1) > bestSoFarFit
    bestSoFarSolution = pop_dec(pop_index_sorted(1));
    bestSoFarFit = pop_fitness_sorted(1);
end

nbGen = nbGen + 1;
nbEval = nbEval + popsize;
solution_gen = [solution_gen, bestSoFarSolution];
fitness_gen = [fitness_gen, bestSoFarFit];

% Start the loop
while (nbEval<T) 
    % Reproduction (selection, crossver)
    prob = pop_fitness ./ sum(pop_fitness);
    offs_bin = [];
    for i = 1:popsize/2
        parent_index = [];
        for j = 1:2
            r = rand();
            for pop_index = 1:popsize
                if r>sum(prob(1:pop_index-1)) && r<=sum(prob(1:pop_index))
                    parent_index = [parent_index, pop_index];
                    break;
                end
            end
        end

        cross_p = randi(bin_len-1);
        offs_bin = [offs_bin; [pop_bin(parent_index(1), 1:cross_p), pop_bin(parent_index(2), cross_p+1:end)]];
        offs_bin = [offs_bin; [pop_bin(parent_index(2), 1:cross_p), pop_bin(parent_index(1), cross_p+1:end)]];
    end

    % Mutation
    prob = 1 / bin_len;
    for i = 1:popsize
        isMutation = rand(1, bin_len) < prob;
        offs_bin(i, isMutation) = dec2bin('1'-offs_bin(i, isMutation));
    end
    
    pop_bin = offs_bin;
    pop_dec = bin2dec(pop_bin);
    
    % Evaluation
    pop_fitness = objective(pop_dec);
    [pop_fitness_sorted, pop_index_sorted] = sort(pop_fitness, 1, 'descend');
    fitness_pop = [fitness_pop, pop_fitness_sorted(1)];
    if pop_fitness_sorted(1) > bestSoFarFit
        bestSoFarSolution = pop_dec(pop_index_sorted(1));
        bestSoFarFit = pop_fitness_sorted(1);
    end

    nbGen = nbGen + 1;
    nbEval = nbEval + popsize;
    solution_gen = [solution_gen, bestSoFarSolution];
    fitness_gen = [fitness_gen, bestSoFarFit];
end

bestSoFarSolution
bestSoFarFit

figure, plot(1:nbGen, fitness_gen, 'b') 
title('Fitness\_Gen')

figure, plot(1:nbGen, solution_gen, 'b') 
title('Solution\_Gen')

figure, plot(1:nbGen, fitness_pop, 'b') 
title('Fitness\_Pop')





