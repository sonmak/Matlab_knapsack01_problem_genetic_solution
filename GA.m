%%
%Sofiya Makarenka - 308912
%Ada Kawala - 304135

%%
clc
clear
close all

%% wygenerowanie wartości
numerAlbumu = 304135; 
rng(numerAlbumu);
N=32;
items(:,1) = round(0.1+0.9*rand(N,1),1);
items(:,2) = round(1+99*rand(N,1));

%% paramentryzacja stałych
W = items(:,1)';
V = items(:,2)';

maxWeight = 0.3*sum(W);

populationSize = 205;
eliteCount = 0.05;

mutationP = 0.01;


%% robimy tak, żeby nasza object function na wejściu miała tylko jeden parametr
fitnessHandler = @(X) fitness(W, V, maxWeight, X);

options = optimoptions('ga','PopulationType', 'bitstring', 'FitnessLimit', -981, 'MaxGenerations', 1000000,...
                       'MaxStallGenerations', 1000000, 'PopulationSize', populationSize, 'EliteCount', ceil(eliteCount*populationSize),...
                       'MutationFcn', {@mutationuniform, mutationP});
%options = optimoptions('ga','PopulationType', 'bitstring','PopulationSize', populationSize, 'EliteCount', ceil(eliteCount*populationSize) ); %defaultowe opcji
%options.CrossoverFraction = 0;

[x,fval,exitflag,out,scores,generations]  = gaHandler(fitnessHandler, 32, options);
[minV, maxV, meanV, varV] = calculateScores(out, generations);
fig = gaPlotChanges(minV, maxV, meanV, varV);

clear varV meanV minV maxV items numerAlbumu 

%% końcowe wartości kosztu i wagi
weightEnd = countWeight(x, W);
valueEnd = countValue(x,V);


%% koszt obliczeniowy
generationsN = out.generations;
costs = populationSize*generationsN;

%% funkcja object = fitness
function y = fitness(W, V, maxWeight, X)
    weight = countWeight(X, W);
    value = countValue(X, V);
    if weight > maxWeight
        y = 3000;
    else
        y = - value;
    end
end

%% funkcja oblicza koszt poszczególnego plecaka
function value = countValue(X, V)
    value = sum(V.*X);
end

%% funkcja oblicza wagę poszczególnego plecaka
function weight = countWeight(X, W)
    weight = sum(W.*X);
end

%% dekorator do wywoływania optymalizacji
function [x,fval,exitflag,out,scores,generations] = gaHandler(fitnessHolder, N, options)
    generations.Score = [];
    
    i = 1;
    
    options.OutputFcn = @output;
    
    [x,fval,exitflag,out,scores] = ga(fitnessHolder, N, [], [], [], [], [], [], [], options);
    
    %% wlasna funkcja output optymalizacji
    function [state,options,optchanged] = output(options,state,flag)
        optchanged = false;

        switch flag
            case 'iter'
                generations.Score(i).res = state.Score;
                i = i + 1;
            case 'interrupt'
                
            case 'init'
                
            case 'done'
              
            otherwise
        end
    end
end

%% obliczenia min man mean and var w funkcji
function [minV, maxV, meanV, varV] = calculateScores(out, generations)
    n = out.generations;
    for i = 1 : n
        minV(i) = min(generations.Score(i).res);
        maxV(i) =  max(generations.Score(i).res);
        meanV(i) = mean(generations.Score(i).res);
        varV(i) = var(generations.Score(i).res);
    end
    
end

%% wykresy min man mean and var w funkcji pokolenia
function fig = gaPlotChanges(minV, maxV, meanV, varV)
    fig = figure;
   
    figure(1)
    plot(1 : length(maxV), maxV, '-*', 'LineWidth', 1.5);
    grid on
    hold on
    plot(1 : length(minV), minV, '-*', 'LineWidth', 1.5);
    plot(1 : length(meanV), meanV, '-*', 'LineWidth', 1.5);
    xlabel('Generation');
    legend('max', 'min', 'mean', 'Location', 'southeast');
    title('Max, Min and Mean Scores');
    hold off

    figure(2)
    plot(1 : length(varV), varV, '-*', 'LineWidth',2);
    grid on
    xlabel('Generation');
    title('Var Scores');
end
