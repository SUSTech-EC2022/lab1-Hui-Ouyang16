clear
close
objective = @quadratic_fitness; % Minimization
dimension = 30;
lower_bound = -30 * ones(1,dimension);
upper_bound = 30 * ones(1,dimension);
T = 500000;
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = inf; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%% Below starting your code
% Initialise a population
mu = 30;% Population size
lambda = 30; % Offspring size
recombination_weight = 0.4;
population = rand(mu, dimension).*(upper_bound-lower_bound) + lower_bound;

fitness = nan(mu, 1);
Maxgen = floor(T/lambda);
fitness_pop = nan(1,Maxgen);
fitness_gen = nan(1,Maxgen);
% Evaluate the initial population
for i = 1:mu
    fitness(i) = objective(population(i,:));
    if fitness(i) < bestSoFarFit
        bestSoFarFit = fitness(i);
        bestSoFarSolution = population(i,:);
    end
    nbEval = nbEval + 1;
end
nbGen = nbGen+1;
fitness_gen(nbGen) = bestSoFarFit;
fitness_pop(nbGen) = min(fitness);
% Start the loop
while (nbEval<T) % [QUESTION] this stopping condition is not perfect, why?
% Reproduction (selection, crossver)
%% Parent selection
Scaled_fitness = simple_fitness_scaling(-fitness); % fitness scaling
crossoverProb = roulette_wheel_selection(Scaled_fitness); 
offspring = nan(lambda, dimension);
offspring_fitness = nan(lambda, 1);
for i = 1:lambda/2
    parentIndexes = nan(1,2);
    for j = 1:2
        r = rand();
        for index = 1:mu
            if r>sum(crossoverProb(1:index-1)) && r<=sum(crossoverProb(1:index))
                break;
            end
        end
        parentIndexes(j) = index;
    end
    %% Recombination method
    [offspring(2*i-1,:), offspring(2*i,:)] = Arithmetic(population(parentIndexes(1),:), population(parentIndexes(2),:), recombination_weight);
end


%% Mutation
mutation_rate = 1/dimension;
for i = 1:lambda
    % mutation method
    offspring(i,:) = Uniform_Mutation(offspring(i,:),mutation_rate, lower_bound, upper_bound);
    offspring_fitness(i) = objective(offspring(i,:));
end

for i = 1:lambda
    if offspring_fitness(i) < bestSoFarFit
        bestSoFarFit = offspring_fitness(i);
        bestSoFarSolution = offspring(i,:);
    end
    nbEval = nbEval + 1;
end
%% Replacement(Survivor Selection)
Scaled_fitness_all = simple_fitness_scaling(-[fitness; offspring_fitness]);
[~,sortedi] = sort(Scaled_fitness_all,'descend');
parent_survivors = sortedi(sortedi(1:mu)<=mu);
offspring_survivors = sortedi(sortedi(1:mu)>mu)-mu;
population = [population(parent_survivors,:); offspring(offspring_survivors,:) ];
fitness = [fitness(parent_survivors); offspring_fitness(offspring_survivors)];

nbGen = nbGen+1;
fitness_gen(nbGen) = bestSoFarFit;
fitness_pop(nbGen) = min(fitness);
end
bestSoFarFit
bestSoFarSolution

figure,plot(log10([1:length(fitness_gen)]),fitness_gen,'b') 
xlabel('log10 Generation')
ylabel('Best-so-far fitness')
title('Arithmetic + RouletteWheelSelection')

figure,plot(log10([1:length(fitness_pop)]),fitness_pop,'b') 
xlabel('log10 Generation')
ylabel('Best currently')
title('Arithmetic + RouletteWheelSelection')
