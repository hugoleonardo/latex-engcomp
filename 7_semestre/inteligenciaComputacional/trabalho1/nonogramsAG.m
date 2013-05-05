%function [mat] = nonogramsAG(size_lin, size_col);

% 1 Trabalho de Inteligência Computacional ( AG para resolver nonograms)
clear all; close all; clc;

% Definição dos valores de cada linha e coluna referentes à formação da
% figura
%lin1 = [1,1];
%lin2 = [1,2];
%lin3 = [4];
%lin4 = [3,1];
%col1 = [2,3];
%col2 = [3];
%col3 = [1,1,2];
%col4 = [2,1];


 
rand1 = rand(1); %numero aleatorio usado como criterio de decisão pra gerar matriz inicial (população inicial)
mat_zeros = zeros(size_lin); %matriz de zeros
mat_ones = ones(size_col); % matriz de uns

for i =1:size_lin,
    for j=1:size_col,
        if  (rand1 < 0.5)
            mat(i,j) = mat_ones(i,j) - mat_zeros(i,j);
        else
            mat(i,j) = 0;
        end
        rand1 = rand(1);
    end
end    



    


