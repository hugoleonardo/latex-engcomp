%function [mat] = nonogramsAG(size_lin, size_col);

% 1 Trabalho de Intelig�ncia Computacional ( AG para resolver nonograms)
clear all; close all; clc;

% Defini��o dos valores de cada linha e coluna referentes � forma��o da
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
         
n_lin = 9;
n_col = 8;
rand1 = rand(1); %numero aleatorio usado como criterio de decis�o pra gerar matriz inicial (popula��o inicial)
t0 = 0; %temperatura inicial
t = 0; %temperatura corrente
p = rand(1); 
p_1 = rand(1);


mat_temp (n_lin,n_col) = 0;
% Cria uma matriz aleat�ria com 0's e 1's a atribui essa matriz � X
% (solu��o inicial)
for i=1:n_lin,
    for j=1:n_col,
        if  (rand1 < 0.5)
            mat_temp(i,j) = 1;
        else
            mat_temp(i,j) = 0;
        end
            rand1 = rand(1);
    end
        
end

mat_final (n_lin,n_col) = 0;
% Atribui X* = X
for i=1:n_lin,
    for j=1:n_col,
        mat_final(i,j) = mat_temp(i,j);
    end        
end
t = 1; %vari�vel que controla o while pra comparar os �ndices
n_max_indices = 2; %n�mero m�ximo de �ndices em cada linha e coluna
count_1 =0; %vari�vel para contar o n�mero de 1's de um linha ou coluna 
passou_indice = 0; % indica quando um indice � lido
indice1 = 0;
indice2 = 0;
aptidao_lin = 0;
aptidao_col = 0;
aptidao_lin_temp = 0;
aptidao_col_temp = 0;
aptidao_avg = 0;
vet_indices_lin_temp (n_lin,n_col) = 0; % matriz tempor�ria para armazenamento dos indices das linhas
vet_indices_col_temp (n_lin,n_col) = 0; % matriz tempor�ria para armazenamento dos indices das colunas
vet_aptidao_lin (n_lin,1) = 0; % vetor que armazena as aptid�es das linhas
vet_aptidao_col (1,n_col) = 0; % vetor que armazena as aptid�es das colunas
qtd_indices = 0; % armazena o qtde de indices em uma linha da matriz


for l=1:n_lin, 
    indice1 = mat_lin(l,1);
    indice2 = mat_lin(l,2);
    for m=1:n_col,
        if mat_final(l,m) == 1;
            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na linha
            if m == n_col, 
                vet_indices_lin_temp(l,m-1) = count_1; %verifica se o �ltimo elemento da linha � 1 e atribui o n�mero de 1's � matriz com os indices
                qtd_indices = qtd_indices +1;
            end
        else
            if m == 1,  % verifica se o elemento � o primeiro da coluna, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                        % isso � pra evitar que quando chegue na �ltima
                        % coluna n�o haja espa�o para armazenar, pq o
                        % armazenamento s� ocorre na pr�xima itera��o
                vet_indices_lin_temp(l,m) = count_1;
                if mat_final(l,m) == 0
                    qtd_indices = qtd_indices;
                end
            else 
                vet_indices_lin_temp(l,m-1) = count_1;
                    if mat_final(l,m-1) == 0
                        qtd_indices = qtd_indices;
                    else
                qtd_indices = qtd_indices +1;
                end
            end
            count_1 = 0;
            qtd_indices = qtd_indices;
        end 
    end % marca o fim da leitura de um elemento
    count_1 = 0;
    
    aptidao_lin_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's
    
    for m=1:n_col,
        if vet_indices_lin_temp(l,m) ~= 0,
            passou_indice = passou_indice + 1;
            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_lin_temp(l,m) == mat_lin(l,passou_indice))
                aptidao_lin = aptidao_lin + aptidao_lin_temp;
            end
        else 
            passou_indice = passou_indice;
            aptidao_lin = aptidao_lin;
        end
     end % marca o fim da leitura de um elemento
     vet_aptidao_lin (l,1) = aptidao_lin;
     aptidao_lin = 0;
     passou_indice = 0;
     qtd_indices = 0;
end % marca o fim da leitura de uma linha
    
       
    
% Percorre as colunas para calcular os �ndices
for m=1:n_col, 
    indice1 = mat_col(m,1);
    indice2 = mat_col(m,2);
    for l=1:n_lin,
        if mat_final(l,m) == 1;
            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na coluna
            espaco = 0;
            if l == n_lin, 
                vet_indices_col_temp(l-1,m) = count_1; %verifica se o �ltimo elemento da coluna � 1 e atribui o n�mero de 1's � matriz com os indices
                qtd_indices = qtd_indices +1;
            end
        else
            if l == 1,  % verifica se o elemento � o primeiro da coluna, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                        % isso � pra evitar que quando chegue na �ltima
                        % coluna n�o haja espa�o para armazenar, pq o
                        % armazenamento s� ocorre na pr�xima itera��o
                vet_indices_lin_temp(l,m) = count_1;
                if mat_final(l,m) == 0
                    qtd_indices = qtd_indices;
                end
            else 
                vet_indices_col_temp(l-1,m) = count_1;
                if mat_final(l-1,m) == 0
                        qtd_indices = qtd_indices;
                    else
                qtd_indices = qtd_indices +1;
                end
            end
            count_1 = 0;
            qtd_indices = qtd_indices;
        end
    end % marca o fim da leitura de um elemento
    count_1 = 0;
    
    aptidao_col_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's
    
    for l=1:n_lin,
        if vet_indices_col_temp(l,m) ~= 0,
            passou_indice = passou_indice + 1;
            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_col_temp(l,m) == mat_col(m,passou_indice))
                aptidao_col = aptidao_col + aptidao_col_temp;
            end
        else 
            passou_indice = passou_indice;
            aptidao_col = aptidao_col;
        end
     end % marca o fim da leitura de um elemento
     vet_aptidao_col (1,m) = aptidao_col;
     aptidao_col = 0;
     passou_indice = 0;
     qtd_indices = 0;
end % marca o fim da leitura de uma coluna


