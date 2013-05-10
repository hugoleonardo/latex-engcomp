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
vet = [2;2;2;2;1;1;1;1];
%Populacao Inicial
npop = 5000;
pop(npop,nlin,ncol) = 0;
aval(npop) = 0;
%Iniciando linhas
for n=1:npop,
    for i=1:nlin,
        %se tiver apenas um grupo de X deve alocar um indice considerando o
        %numero de Xs do grupo para nao extrapolar o numero de colunas
        if(matl(i,2) < 1)
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
% k = squeeze(pop(1,:,:)) para a primeira matriz 2D
% k = squeeze(pop(2,:,:)) para a segunda matriz 2D
% vai ate o npop

%Avaliacao
%Primeiro passo
%checar o numero de Xs na coluna
%Segundo passo
%
%inicializando variaveis de controle
%eh possivel haver no maximo 4 pesos em 8 colunas ou 5 em 9 colunas
%o round arredonda pra mais
peso(round(nlin/2))=0;
%flag para indicar sequencias de Xs
flag=false;
for n=1:npop,
    tmp = squeeze(pop(n,:,:))
    for j=1:ncol,
        %zera o contador de Xs a cada troca de coluna
        contador_x=0;
        %zera o contador de pesos a cada troca de coluna
        contador_peso=0;
        for i=1:nlin,
            %encontra X da coluna
            if(i==nlin && pop(n,i,j)==1 && contador_x==0)
                contador_peso=contador_peso+1;
                peso(contador_peso)=1;
                contador_x=0;
            elseif(pop(n,i,j)==1)
                contador_x=contador_x+1;
            %se encontrar um vazio, checa se o contador saiu de zero para
            %indicar se houve um grupo de Xs
            elseif(pop(n,i,j)==0 && contador_x~=0)
                %indica a existencia de um novo peso
                contador_peso=contador_peso+1;
                %guarda o novo peso no vetor de pesos
                peso(contador_peso)=contador_x;
                contador_x=0;
            %captura caso um grupo de X na ultima linha da coluna
            end
            if(contador_x>1 && i==nlin)
                %indica a existencia de um novo peso
                contador_peso=contador_peso+1;
                %guarda o novo peso no vetor de pesos
                peso(contador_peso)=contador_x;
                contador_x=0;
            end
           
        end
        %a maior taxa de peso eh metade do total
        %taxa_peso=1/(2*ncol);
        
        %a = 100/contador_peso;
        %1 3 1 7 5 3 4 3
        %2 1 5 1
        %proporcao de aptidao da coluna na matriz de acordo com o numero de
        %pesos achados, nesse caso eh se for maior de 2 pesos
        %if(contador_peso>2)
        %    taxa_peso=1/(contador_peso*ncol);
        %end
        cont=0;
        for tmp=1:2,
            if(peso(tmp)==matc(j,tmp) && matc(j,tmp)~=0)
                cont=cont+1;
            end
        end
        
        if(contador_peso<vet(j))
            contador_peso = vet(j);
        end
        %taxa parcial da matriz na coluna atual
        taxa_col = cont*(1/contador_peso);
        %taxa parcial normalizada da matriz na coluna atual
        taxa_col_n = taxa_col/ncol;
        aval(n) = aval(n) + taxa_col_n;
        %zera o vetor de pesos a cada coluna
        for tmp=1:(round(nlin/2)),
            peso(tmp)=0;
        end
    end
end

