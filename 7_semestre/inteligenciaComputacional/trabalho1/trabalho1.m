%AG Inteligencia Artificial

%Problem statement:          Solution:

%  |_|_|_|_|_|_|_|_| 3         |_|X|X|X|_|_|_|_| 3
%  |_|_|_|_|_|_|_|_| 2 1       |X|X|_|X|_|_|_|_| 2 1
%  |_|_|_|_|_|_|_|_| 3 2       |_|X|X|X|_|_|X|X| 3 2
%  |_|_|_|_|_|_|_|_| 2 2       |_|_|X|X|_|_|X|X| 2 2
%  |_|_|_|_|_|_|_|_| 6         |_|_|X|X|X|X|X|X| 6
%  |_|_|_|_|_|_|_|_| 1 5       |X|_|X|X|X|X|X|_| 1 5
%  |_|_|_|_|_|_|_|_| 6         |X|X|X|X|X|X|_|_| 6
%  |_|_|_|_|_|_|_|_| 1         |_|_|_|_|X|_|_|_| 1
%  |_|_|_|_|_|_|_|_| 2         |_|_|_|X|X|_|_|_| 2
%   1 3 1 7 5 3 4 3             1 3 1 7 5 3 4 3
%   2 1 5 1                     2 1 5 1

%limpa cache
clear all; close all; clc;

%Criterio de avaliacao
espliv = 1;
index(9,2) = 0;
%linhas
nlin = 9;
matl =[ 
    3,0;
    2,1;
    3,2;
    2,2;
    6,0;
    1,5;
    6,0;
    1,0;
    2,0
    ];
%colunas
ncol = 8;
matc =[ 
    1,2;
    3,1;
    1,5;
    7,1;
    5,0;
    3,0;
    4,0;
    3,0
    ];
%Populacao Inicial
npop = 15;
pop(npop,nlin,ncol) = 0;
%Iniciando linhas
for n=1:npop,
    for i=1:nlin,
        %se tiver apenas um grupo de X deve alocar um indice considerando o
        %numero de Xs do grupo para não extrapolar o numero de colunas
        if(matl(i,2)<1)
            index(i,1) =  randi([1, ncol-matl(i,1)]+1);
            %preenche o unico grupo de Xs na matriz da linha i
            for x=index(i,1):(index(i,1)+matl(i,1)-1),
                pop(n,i,x)=1;
            end
            %o segundo indice da linha nao precisa ser procurado nesse caso
            continue;
        end
        %caso haja 2 indices deve-se achar um indice de forma que haja pelo
        %menos um espaco entre os dois grupos e tambem deve-se considerar o
        %numero de Xs do outro grupo
        index(i,1) = randi([1, ncol-matl(i,1)-matl(i,2)]);
        index(i,2) = randi([index(i,1)+matl(i,1)+espliv, ncol-matl(i,2)+1]);
        %preenche o primeiro grupo de Xs na matriz da linha i
        for x=index(i,1):(index(i,1)+matl(i,1)-1),
            pop(n,i,x)=1;
        end
        %preenche o segundo grupo de Xs na matriz da linha i
        for x=index(i,2):(index(i,2)+matl(i,2)-1),
            pop(n,i,x)=1;
         end
    end
end

%achar matriz de pop
% k = squeeze(1,:,:) para a primeira matriz 2D
% k = squeeze(2,:,:) para a segunda matriz 2D
% vai até o npop

%Avaliacao
%Primeiro passo
%checar o numero de Xs na coluna
%Segundo passo
%



for n=1:npop,
    for j=1:ncol,
        for i=1:nlin,
            pop(n,i,j); 
        end
    end
end

