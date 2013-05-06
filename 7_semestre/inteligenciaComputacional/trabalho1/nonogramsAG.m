%function [mat] = nonogramsAG(size_lin, size_col);

% 1 Trabalho de Inteligência Computacional ( AG para resolver nonograms)
clear all; close all; clc;

% Definição dos valores de cada linha e coluna referentes à formação da
% figura
mat_lin =   [3,0;
            2,1;
            3,2;
            2,2;
            6,0;
            1,5;
            6,0;
            1,0;
            2,0];
mat_col =   [1,2;
             3,1;
             1,5; 
             7,1;
             5,0;
             3,0;
             4,0;
             3,0];
         
size_lin = 8;
size_col = 9;
%Controla se alterou o valor de uma célula
control = false;
indice = 0;
coluna = 0;
rand1 = rand(1); %numero aleatorio usado como criterio de decisão pra gerar matriz inicial (população inicial)
mat_zeros = zeros(size_lin); %matriz de zeros
mat_ones = ones(size_col); % matriz de uns

for i=1:size_lin,
    for j=1:size_col,
        if  (rand1 < 0.5)
            if j > 8 
            mat(i,j) = 1;
            else
                mat(i,j) = mat_ones(i,j) - mat_zeros(i,j);
            end
        else
            if j > 8 
            mat(i,j) = 0;
            else
                mat(i,j) = 0;
            end
        end
        rand1 = rand(1);
    end
end    
indice_lin = 0;
indice_col = 0;
aptidao = 0;

for i=1:size_col,
    for j=1:size_lin,
        indice_lin = mat_lin(
    end
end

