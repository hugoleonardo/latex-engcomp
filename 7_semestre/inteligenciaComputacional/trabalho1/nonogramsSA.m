%=================================================================
%Simmulated Annealing - Nonograms Puzzle - Inteligencia Artificial
% ================================================================
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

% ================================================================
%                       Vari�veis - Algoritmo (SA)
% ================================================================
% X     ---> Solu��o da itera��o corrente
% X*    ---> Melhor solu��o encontrada
% f(x)  ---> Fun��o Objetivo
%               A fun��o objetivo para este problema foi definida como f(x)
%               = 1/((aptid�o_media_linha + aptid�o_media_coluna)/2)
%            A fun��o representa o custo de cada matriz, ou seja, quanto
%            maior for a aptid�o, menor ser� o custo, portanto, matrizes
%            com um custo melhor ser�o escolhidas como melhor solu��o
% T0    ---> Temperatura inicial
% T     ---> Temperatura corrente
% p     ---> Crit�rio de Metropolis (exp(-Delta_E/T))



% ================================================================
%                       Passo a passo do algoritmo
% ================================================================
% Passo 1: Atribuir uma solu��o inicial (aleat�ria) (X)
% Passo 2: Definir a solu��o inicial como solu��o �tima (X*)
% Passo 3: Definir temperatura inicial (T0)
% Passo 4: Verificar se a solu��o atende �s condi��es de parada (verificar
% se os 1's da matriz atendem aos pesos das linhas e colunas
% Passo 5: Escolher uma matriz vizinha de X (X')
% Passo 6: Calcular Delta_E = (f(X') - f(X))
% Passo 7: Verificar se Delta_E < 0
% Passo 8: Se passo 7 for verdadeiro, X = X'. Se (f(X') < f(X*)), X* = X'
% Passo 9: Se passo 7 for falso, gerar p'. Se (p' < exp(-Delta_E/T)), X=X'
% Passo 10: Retornar ao passo 5
% Passo 11: Atualizar T
% Passo 12: retornar ao passo 4

%limpa cache
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




% ================================================================
%                       Vari�veis - Programa
% ================================================================


% ******************* Vari�veis de Controle **************************
count_1 =0; %vari�vel para contar o n�mero de 1's de um linha ou coluna 
passou_indice = 0; % indica quando um indice � lido
qtd_indices = 0; % armazena o qtde de indices em uma linha da matriz
iter = 0; % vari�vel que guarda o n�mero de itera��es realizadas
delta_e = 0; % diferen�a entre os custos de f(X') - f(X) 
n_ciclos = 0; % n�mero de ciclos de resfriamentos
n_temperatura = 0; % n�mero de temperatura diferentes
t_max = 1024; % temperatura m�xima 

% ******************* Matrizes **************************
mat_vizinho(n_lin,n_col) = 0; % matriz usada para armazenar as solu��es vizinhas de X (X')
mat_final (n_lin,n_col) = 0; % matriz que recebe a melhor solu��o encontrada (X*)
mat_temp (n_lin,n_col) = 0; % matriz aleat�ria com 0's e 1's (solu��o inicial - X)
vet_indices_lin_temp (n_lin,n_col) = 0; % matriz tempor�ria para armazenamento dos indices das linhas
vet_indices_col_temp (n_lin,n_col) = 0; % matriz tempor�ria para armazenamento dos indices das colunas

% ******************* Vari�veis de resultado **************************
aptidao_lin = 0; % indica a aptid�o de uma linha
aptidao_col = 0; % indica a aptid�o de uma coluna
aptidao_lin_temp = 0; % indica a aptid�o para cada grupo de 1's de uma linha 
aptidao_col_temp = 0; % indica a aptid�o para cada grupo de 1's de uma coluna
aptidao_lin_avg = 0; % indica a aptid�o m�dia de uma linha 
aptidao_col_avg = 0; % indica a aptid�o m�dia de uma coluna
aptidao_avg_temp = 0; % indica a aptid�o m�dia da matriz corrente (X)
aptidao_avg_vizinho = 0; % indica a aptid�o m�dia da matriz vizinha (X')
aptidao_avg_final = 0; % indica a aptid�o m�dia da matriz vizinha (X')
custo_temp = 0; % � definido como o inverso da aptid�o da matriz, usado para definir se uma matriz vai ou n�o se tornar a nova solu��o. Custo da matriz corrente (X)
custo_vizinho = 0; % � definido como o inverso da aptid�o da matriz, usado para definir se uma matriz vai ou n�o se tornar a nova solu��o. Custo da matriz vizinha (X')
custo_final = 0; % � definido como o inverso da aptid�o da matriz, usado para definir se uma matriz vai ou n�o se tornar a nova solu��o. Custo da matriz final (X*)
vet_aptidao_lin (n_lin,1) = 0; % vetor que armazena as aptid�es das linhas
vet_aptidao_col (1,n_col) = 0; % vetor que armazena as aptid�es das colunas
vet_resultado_custo(1,iter+1) = 0;
vet_resultado_aptidao(1,iter+1) = 0;
vet_resultado_avg_aptidao(1,n_temperatura+1) = 0;
vet_n_temperatura (1,n_temperatura+1) = 0;

% ******************* Par�metros do SA **************************
%t =1; % temperatura corrente
t_inicial = 1; % temperatura auxiliar que vai ajudar na varia��o da temperatura
alpha = 0.9; % cte de resfriamento
k = 1;
beta = 0.00001;
temperatura_congelamento = 0.00001;

% ================================================================
%                           IN�CIO
% ================================================================


% gera solu��o inicial (X)
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


% atribui X* = X
for i=1:n_lin,
    for j=1:n_col,
        mat_final(i,j) = mat_temp(i,j);
    end        
end



% ================================================================
%                C�lculo da aptid�o/custo da matriz final (X*)
% ================================================================
vet_indices_lin_temp (n_lin,n_col) = 0;
vet_indices_col_temp (n_lin,n_col) = 0;
vet_aptidao_lin = 0;
vet_aptidao_col = 0;
aptidao_lin_avg = 0;
aptidao_col_avg = 0;
% Percorre as linhas para calcular os �ndices
for l=1:n_lin, 
    for m=1:n_col,
        if mat_final(l,m) == 1;
            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na linha
            if m == n_col, 
                vet_indices_lin_temp(l,m-1) = count_1; %verifica se o �ltimo elemento da linha � 1 e atribui o n�mero de 1's � matriz com os indices
                qtd_indices = qtd_indices +1; %quando chega na �ltima coluna, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
            end
        else
            if m == 1,  % verifica se o elemento � o primeiro da linha, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                        % isso � pra evitar que quando chegue na �ltima
                        % coluna n�o haja espa�o para armazenar, pq o
                        % armazenamento s� ocorre ap�s a leitura do �ltimo
                        % 1 da sequ�ncia
                vet_indices_lin_temp(l,m) = count_1;
                if mat_final(l,m) == 0
                    qtd_indices = qtd_indices;
                end
            else    % se n�o for o primeiro elemento da linha, armazena o valor de count na posi��o anterior, dessa forma o valor do �ndice sempre ser� armazenado
                    % na posi��o correspondente ao �ltimo 1 da sequ�ncia da
                    % matriz que est� sendo analisada 
                vet_indices_lin_temp(l,m-1) = count_1;
                    if mat_final(l,m-1) == 0
                        qtd_indices = qtd_indices; % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                   % s� seja incrementada ao final de uma sequ�ncia de 1's
                    else
                qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                end
            end
            count_1 = 0; % se o valor do elemento for 0 o contador � zerado
            qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
        end 
    end % marca o fim da leitura de um elemento
    count_1 = 0;
    
    aptidao_lin_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's
    
    for m=1:n_col, % percorre a linha da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
        if vet_indices_lin_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                           % se encontrar incrementa
                                           % passou_indice para guardar
                                           % a ordem do �ndice (se o
                                           % primeiro ou o segundo)
            passou_indice = passou_indice + 1;
            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_lin_temp(l,m) == mat_lin(l,passou_indice))  
                % verifica o �ndice com seu respectivo �ndice na matriz dos
                % �ndices, respoeitando a ordem e se for igual atualiza a
                % aptid�o da linha
                aptidao_lin = aptidao_lin + aptidao_lin_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da linha � atualziada
            end
        else 
            passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice 
            aptidao_lin = aptidao_lin;  % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
        end
    end
    % marca o fim da leitura de um elemento
     vet_aptidao_lin (l,1) = aptidao_lin;
     aptidao_lin = 0;
     passou_indice = 0;
     qtd_indices = 0;
end % marca o fim da leitura de uma linha
     
% Percorre as colunas para calcular os �ndices
for m=1:n_col, 
    for l=1:n_lin,
        if mat_final(l,m) == 1;
            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na coluna
            espaco = 0;
            if l == n_lin, 
                vet_indices_col_temp(l-1,m) = count_1; %verifica se o �ltimo elemento da coluna � 1 e atribui o n�mero de 1's � matriz com os indices
                qtd_indices = qtd_indices +1; %quando chega na �ltima linha, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
            end
        else
            if l == 1,  % verifica se o elemento � o primeiro da coluna, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                        % isso � pra evitar que quando chegue na �ltima
                        % linha n�o haja espa�o para armazenar, pq o
                        % armazenamento s� ocorre ap�s a leitura do �ltimo
                        % 1 da sequ�ncia
                vet_indices_lin_temp(l,m) = count_1;
                if mat_final(l,m) == 0
                    qtd_indices = qtd_indices;  % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                % s� seja incrementada ao final de uma sequ�ncia de 1's
                end
            else 
                vet_indices_col_temp(l-1,m) = count_1;
                if mat_final(l-1,m) == 0
                        qtd_indices = qtd_indices;
                    else
                qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                end
            end
            count_1 = 0; % se o valor do elemento for 0 o contador � zerado
            qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
        end
    end
    % marca o fim da leitura de um elemento
    count_1 = 0;
    
    aptidao_col_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's
    
    for l=1:n_lin, % percorre a coluna da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
        if vet_indices_col_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                           % se encontrar incrementa
                                           % passou_indice para guardar
                                           % a ordem do �ndice (se o
                                           % primeiro ou o segundo)
            passou_indice = passou_indice + 1;
            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_col_temp(l,m) == mat_col(m,passou_indice))
                    % verifica o �ndice com seu respectivo �ndice na matriz dos
                    % �ndices, respoeitando a ordem e se for igual atualiza a
                    % aptid�o da linha
                aptidao_col = aptidao_col + aptidao_col_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da coluna � atualziada
            end
        else 
            passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice
            aptidao_col = aptidao_col; % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
        end
    end
    % marca o fim da leitura de um elemento
     vet_aptidao_col (1,m) = aptidao_col;
     aptidao_col = 0;
     passou_indice = 0;
     qtd_indices = 0;
end % marca o fim da leitura de uma coluna

% encontra a m�dia das aptidoes das linhas
aptidao_lin_avg = mean(vet_aptidao_lin); 

% encontra a m�dia das aptidoes das colunas
aptidao_col_avg = mean(vet_aptidao_col); 
    
% encontra a aptid�o da matriz tirando a m�dia entre as m�dias das aptid�es das linhas e das colunas
aptidao_avg_final = (aptidao_lin_avg + aptidao_col_avg)/2;
custo_final = 1/aptidao_avg_final;


while (t_inicial <= t_max),
        % ================================================================
        %                Verificar condi��es de parada
        % ================================================================
        t = t_inicial
        while (t > temperatura_congelamento && custo_final~= 0.01)
            n_t = 50; % n�mero de itera��es com a mesma temperatura
            while n_t > 0
                % ================================================================
                %                C�lculo da aptid�o/custo da matriz corrente (X)
                % ================================================================
                vet_indices_lin_temp (n_lin,n_col) = 0;
                vet_indices_col_temp (n_lin,n_col) = 0;
                vet_aptidao_lin = 0;
                vet_aptidao_col = 0;
                aptidao_lin_avg = 0;
                aptidao_col_avg = 0;
                % Percorre as linhas para calcular os �ndices
                for l=1:n_lin, 
                    for m=1:n_col,
                        if mat_temp(l,m) == 1;
                            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na linha
                            if m == n_col, 
                                vet_indices_lin_temp(l,m-1) = count_1; %verifica se o �ltimo elemento da linha � 1 e atribui o n�mero de 1's � matriz com os indices
                                qtd_indices = qtd_indices +1; %quando chega na �ltima coluna, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
                            end
                        else
                            if m == 1,  % verifica se o elemento � o primeiro da linha, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                                        % isso � pra evitar que quando chegue na �ltima
                                        % coluna n�o haja espa�o para armazenar, pq o
                                        % armazenamento s� ocorre ap�s a leitura do �ltimo
                                        % 1 da sequ�ncia
                                vet_indices_lin_temp(l,m) = count_1;
                                if mat_temp(l,m) == 0
                                    qtd_indices = qtd_indices;
                                end
                            else    % se n�o for o primeiro elemento da linha, armazena o valor de count na posi��o anterior, dessa forma o valor do �ndice sempre ser� armazenado
                                    % na posi��o correspondente ao �ltimo 1 da sequ�ncia da
                                    % matriz que est� sendo analisada 
                                vet_indices_lin_temp(l,m-1) = count_1;
                                    if mat_temp(l,m-1) == 0
                                        qtd_indices = qtd_indices; % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                                   % s� seja incrementada ao final de uma sequ�ncia de 1's
                                    else
                                qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                                end
                            end
                            count_1 = 0; % se o valor do elemento for 0 o contador � zerado
                            qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
                        end 
                    end % marca o fim da leitura de um elemento
                    count_1 = 0;

                    aptidao_lin_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's

                    for m=1:n_col, % percorre a linha da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
                        if vet_indices_lin_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                                           % se encontrar incrementa
                                                           % passou_indice para guardar
                                                           % a ordem do �ndice (se o
                                                           % primeiro ou o segundo)
                            passou_indice = passou_indice + 1;
                            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_lin_temp(l,m) == mat_lin(l,passou_indice))  
                                % verifica o �ndice com seu respectivo �ndice na matriz dos
                                % �ndices, respoeitando a ordem e se for igual atualiza a
                                % aptid�o da linha
                                aptidao_lin = aptidao_lin + aptidao_lin_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da linha � atualziada
                            end
                        else 
                            passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice 
                            aptidao_lin = aptidao_lin;  % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
                        end
                    end
                    % marca o fim da leitura de um elemento
                     vet_aptidao_lin (l,1) = aptidao_lin;
                     aptidao_lin = 0;
                     passou_indice = 0;
                     qtd_indices = 0;
                end % marca o fim da leitura de uma linha

                % Percorre as colunas para calcular os �ndices
                for m=1:n_col, 
                    for l=1:n_lin,
                        if mat_temp(l,m) == 1;
                            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na coluna
                            espaco = 0;
                            if l == n_lin, 
                                vet_indices_col_temp(l-1,m) = count_1; %verifica se o �ltimo elemento da coluna � 1 e atribui o n�mero de 1's � matriz com os indices
                                qtd_indices = qtd_indices +1; %quando chega na �ltima linha, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
                            end
                        else
                            if l == 1,  % verifica se o elemento � o primeiro da coluna, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                                        % isso � pra evitar que quando chegue na �ltima
                                        % linha n�o haja espa�o para armazenar, pq o
                                        % armazenamento s� ocorre ap�s a leitura do �ltimo
                                        % 1 da sequ�ncia
                                vet_indices_lin_temp(l,m) = count_1;
                                if mat_temp(l,m) == 0
                                    qtd_indices = qtd_indices;  % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                                % s� seja incrementada ao final de uma sequ�ncia de 1's
                                end
                            else 
                                vet_indices_col_temp(l-1,m) = count_1;
                                if mat_temp(l-1,m) == 0
                                        qtd_indices = qtd_indices;
                                    else
                                qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                                end
                            end
                            count_1 = 0; % se o valor do elemento for 0 o contador � zerado
                            qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
                        end
                    end
                    % marca o fim da leitura de um elemento
                    count_1 = 0;

                    aptidao_col_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's

                    for l=1:n_lin, % percorre a coluna da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
                        if vet_indices_col_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                                           % se encontrar incrementa
                                                           % passou_indice para guardar
                                                           % a ordem do �ndice (se o
                                                           % primeiro ou o segundo)
                            passou_indice = passou_indice + 1;
                            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_col_temp(l,m) == mat_col(m,passou_indice))
                                    % verifica o �ndice com seu respectivo �ndice na matriz dos
                                    % �ndices, respoeitando a ordem e se for igual atualiza a
                                    % aptid�o da linha
                                aptidao_col = aptidao_col + aptidao_col_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da coluna � atualziada
                            end
                        else 
                            passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice
                            aptidao_col = aptidao_col; % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
                        end
                    end
                    % marca o fim da leitura de um elemento
                     vet_aptidao_col (1,m) = aptidao_col;
                     aptidao_col = 0;
                     passou_indice = 0;
                     qtd_indices = 0;
                end % marca o fim da leitura de uma coluna

                % encontra a m�dia das aptidoes das linhas
                aptidao_lin_avg = mean(vet_aptidao_lin); 

                % encontra a m�dia das aptidoes das colunas
                aptidao_col_avg = mean(vet_aptidao_col); 

                % encontra a aptid�o da matriz tirando a m�dia entre as m�dias das aptid�es das linhas e das colunas
                aptidao_avg_temp = (aptidao_lin_avg + aptidao_col_avg)/2;
                custo_temp = 1/aptidao_avg_temp;


                % ================================================================
                %                Escolher matriz vizinha
                % ================================================================
                % Procura uma linha com aptid�o 0 e reescreve essa linha
                % aleatoriamente, repetindo as linhas da matriz X que possuem
                % aptid�o diferente de 0
                %{ 
                for i=1:n_lin
                    for j=1:n_col
                        if vet_aptidao_lin(i,1) == 0,
                            if  (rand1 < 0.5)
                                mat_vizinho(i,j) = 1;
                            else
                                mat_vizinho(i,j) = 0;
                            end
                                rand1 = rand(1);
                        else
                            mat_vizinho(i,j) = mat_temp(i,j);
                        end
                    end
                end
                %}
                % Preenche de forma aleat�rio a matriz vizinha (X')
                %{
                for i=1:n_lin,
                    for j=1:n_col,
                        if  (rand1 < 0.5)
                            mat_vizinho(i,j) = 1;
                        else
                            mat_vizinho(i,j) = 0;
                        end
                            rand1 = rand(1);
                    end
                end
                %}
                % Procura uma linha com aptid�o aleat�ria entre 1 e 100 e reescreve essa linha
                % aleatoriamente, repetindo as linhas da matriz X que possuem
                % aptid�o diferente da aptid�o encontrada
                for i=1:n_lin
                    for j=1:n_col
                        if vet_aptidao_lin(i,1) < randi([1,100]) && vet_aptidao_col(1,m) < randi([1,100]),
                                rand1 = rand(1);
                                if  (rand1 < 0.5)
                                    mat_vizinho(i,j) = 1;
                                else
                                    mat_vizinho(i,j) = 0;
                                end
                        else
                                mat_vizinho(i,j) = mat_temp(i,j);
                        end
                    end
                end
                %}
                % ================================================================
                %            C�lculo da aptid�o/custo da matriz vizinha (X')
                % ================================================================
                vet_indices_lin_temp (n_lin,n_col) = 0;
                vet_indices_col_temp (n_lin,n_col) = 0;
                vet_aptidao_lin = 0;
                vet_aptidao_col = 0;
                aptidao_lin_avg = 0;
                aptidao_col_avg = 0;
                % Percorre as linhas para calcular os �ndices
                for l=1:n_lin, 
                    for m=1:n_col,
                        if mat_vizinho(l,m) == 1;
                            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na linha
                            if m == n_col, 
                                vet_indices_lin_temp(l,m-1) = count_1; %verifica se o �ltimo elemento da linha � 1 e atribui o n�mero de 1's � matriz com os indices
                                qtd_indices = qtd_indices +1; %quando chega na �ltima coluna, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
                            end
                        else
                            if m == 1,  % verifica se o elemento � o primeiro da linha, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                                        % isso � pra evitar que quando chegue na �ltima
                                        % coluna n�o haja espa�o para armazenar, pq o
                                        % armazenamento s� ocorre ap�s a leitura do �ltimo
                                        % 1 da sequ�ncia
                                vet_indices_lin_temp(l,m) = count_1;
                                if mat_vizinho(l,m) == 0
                                    qtd_indices = qtd_indices;
                                end
                            else    % se n�o for o primeiro elemento da linha, armazena o valor de count na posi��o anterior, dessa forma o valor do �ndice sempre ser� armazenado
                                    % na posi��o correspondente ao �ltimo 1 da sequ�ncia da
                                    % matriz que est� sendo analisada 
                                vet_indices_lin_temp(l,m-1) = count_1;
                                    if mat_vizinho(l,m-1) == 0
                                        qtd_indices = qtd_indices; % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                                   % s� seja incrementada ao final de uma sequ�ncia de 1's
                                    else
                                qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                                end
                            end
                            count_1 = 0; % se o valor do elemento for 0 o contador � zerado
                            qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
                        end 
                    end % marca o fim da leitura de um elemento
                    count_1 = 0;

                    aptidao_lin_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's

                    for m=1:n_col, % percorre a linha da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
                        if vet_indices_lin_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                                           % se encontrar incrementa
                                                           % passou_indice para guardar
                                                           % a ordem do �ndice (se o
                                                           % primeiro ou o segundo)
                            passou_indice = passou_indice + 1;
                            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_lin_temp(l,m) == mat_lin(l,passou_indice))  
                                % verifica o �ndice com seu respectivo �ndice na matriz dos
                                % �ndices, respoeitando a ordem e se for igual atualiza a
                                % aptid�o da linha
                                aptidao_lin = aptidao_lin + aptidao_lin_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da linha � atualziada
                            end
                        else 
                            passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice 
                            aptidao_lin = aptidao_lin;  % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
                        end
                    end
                    % marca o fim da leitura de um elemento
                     vet_aptidao_lin (l,1) = aptidao_lin;
                     aptidao_lin = 0;
                     passou_indice = 0;
                     qtd_indices = 0;
                end % marca o fim da leitura de uma linha

                % Percorre as colunas para calcular os �ndices
                for m=1:n_col, 
                    for l=1:n_lin,
                        if mat_vizinho(l,m) == 1;
                            count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na coluna
                            espaco = 0;
                            if l == n_lin, 
                                vet_indices_col_temp(l-1,m) = count_1; %verifica se o �ltimo elemento da coluna � 1 e atribui o n�mero de 1's � matriz com os indices
                                qtd_indices = qtd_indices +1; %quando chega na �ltima linha, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
                            end
                        else
                            if l == 1,  % verifica se o elemento � o primeiro da coluna, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                                        % isso � pra evitar que quando chegue na �ltima
                                        % linha n�o haja espa�o para armazenar, pq o
                                        % armazenamento s� ocorre ap�s a leitura do �ltimo
                                        % 1 da sequ�ncia
                                vet_indices_lin_temp(l,m) = count_1;
                                if mat_vizinho(l,m) == 0
                                    qtd_indices = qtd_indices;  % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                                % s� seja incrementada ao final de uma sequ�ncia de 1's
                                end
                            else 
                                vet_indices_col_temp(l-1,m) = count_1;
                                if mat_vizinho(l-1,m) == 0
                                        qtd_indices = qtd_indices;
                                    else
                                qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                                end
                            end
                            count_1 = 0; % se o valor do elemento for 0 o contador � zerado
                            qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
                        end
                    end
                    % marca o fim da leitura de um elemento
                    count_1 = 0;

                    aptidao_col_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's

                    for l=1:n_lin, % percorre a coluna da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
                        if vet_indices_col_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                                           % se encontrar incrementa
                                                           % passou_indice para guardar
                                                           % a ordem do �ndice (se o
                                                           % primeiro ou o segundo)
                            passou_indice = passou_indice + 1;
                            if (passou_indice == 1 || passou_indice == 2) && (vet_indices_col_temp(l,m) == mat_col(m,passou_indice))
                                    % verifica o �ndice com seu respectivo �ndice na matriz dos
                                    % �ndices, respoeitando a ordem e se for igual atualiza a
                                    % aptid�o da linha
                                aptidao_col = aptidao_col + aptidao_col_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da coluna � atualziada
                            end
                        else 
                            passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice
                            aptidao_col = aptidao_col; % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
                        end
                    end
                    % marca o fim da leitura de um elemento
                     vet_aptidao_col (1,m) = aptidao_col;
                     aptidao_col = 0;
                     passou_indice = 0;
                     qtd_indices = 0;
                end % marca o fim da leitura de uma coluna

                % encontra a m�dia das aptidoes das linhas
                aptidao_lin_avg = mean(vet_aptidao_lin); 

                % encontra a m�dia das aptidoes das colunas
                aptidao_col_avg = mean(vet_aptidao_col); 

                % encontra a aptid�o da matriz tirando a m�dia entre as m�dias das aptid�es das linhas e das colunas
                aptidao_avg_vizinho = (aptidao_lin_avg + aptidao_col_avg)/2;
                custo_vizinho = 1/aptidao_avg_vizinho;

                delta_e = (custo_vizinho - custo_temp);
                p = exp(-(delta_e)/t);
                        if delta_e < 0,
                            % se delta_E < 0, fazer X = X'
                            for i=1:n_lin,
                                for j=1:n_col,
                                    mat_temp(i,j) = mat_vizinho(i,j);
                                end        
                            end
                            if custo_vizinho < custo_final
                                % se f(X') < f(X*), fazer X* = X' e atualiza o custo da
                                % matriz final
                                for i=1:n_lin,
                                    for j=1:n_col,
                                        mat_final(i,j) = mat_vizinho(i,j);
                                    end        
                                end
                                    % ================================================================
                                    %                C�lculo da aptid�o/custo da matriz final (X*)
                                    % ================================================================
                                    vet_indices_lin_temp (n_lin,n_col) = 0;
                                    vet_indices_col_temp (n_lin,n_col) = 0;
                                    vet_aptidao_lin = 0;
                                    vet_aptidao_col = 0;
                                    aptidao_lin_avg = 0;
                                    aptidao_col_avg = 0;
                                    % Percorre as linhas para calcular os �ndices
                                    for l=1:n_lin, 
                                        for m=1:n_col,
                                            if mat_final(l,m) == 1;
                                                count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na linha
                                                if m == n_col, 
                                                    vet_indices_lin_temp(l,m-1) = count_1; %verifica se o �ltimo elemento da linha � 1 e atribui o n�mero de 1's � matriz com os indices
                                                    qtd_indices = qtd_indices +1; %quando chega na �ltima coluna, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
                                                end
                                            else
                                                if m == 1,  % verifica se o elemento � o primeiro da linha, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                                                            % isso � pra evitar que quando chegue na �ltima
                                                            % coluna n�o haja espa�o para armazenar, pq o
                                                            % armazenamento s� ocorre ap�s a leitura do �ltimo
                                                            % 1 da sequ�ncia
                                                    vet_indices_lin_temp(l,m) = count_1;
                                                    if mat_final(l,m) == 0
                                                        qtd_indices = qtd_indices;
                                                    end
                                                else    % se n�o for o primeiro elemento da linha, armazena o valor de count na posi��o anterior, dessa forma o valor do �ndice sempre ser� armazenado
                                                        % na posi��o correspondente ao �ltimo 1 da sequ�ncia da
                                                        % matriz que est� sendo analisada 
                                                    vet_indices_lin_temp(l,m-1) = count_1;
                                                        if mat_final(l,m-1) == 0
                                                            qtd_indices = qtd_indices; % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                                                       % s� seja incrementada ao final de uma sequ�ncia de 1's
                                                        else
                                                    qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                                                    end
                                                end
                                                count_1 = 0; % se o valor do elemento for 0 o contador � zerado
                                                qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
                                            end 
                                        end % marca o fim da leitura de um elemento
                                        count_1 = 0;

                                        aptidao_lin_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's

                                        for m=1:n_col, % percorre a linha da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
                                            if vet_indices_lin_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                                                               % se encontrar incrementa
                                                                               % passou_indice para guardar
                                                                               % a ordem do �ndice (se o
                                                                               % primeiro ou o segundo)
                                                passou_indice = passou_indice + 1;
                                                if (passou_indice == 1 || passou_indice == 2) && (vet_indices_lin_temp(l,m) == mat_lin(l,passou_indice))  
                                                    % verifica o �ndice com seu respectivo �ndice na matriz dos
                                                    % �ndices, respoeitando a ordem e se for igual atualiza a
                                                    % aptid�o da linha
                                                    aptidao_lin = aptidao_lin + aptidao_lin_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da linha � atualziada
                                                end
                                            else 
                                                passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice 
                                                aptidao_lin = aptidao_lin;  % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
                                            end
                                        end
                                        % marca o fim da leitura de um elemento
                                         vet_aptidao_lin (l,1) = aptidao_lin;
                                         aptidao_lin = 0;
                                         passou_indice = 0;
                                         qtd_indices = 0;
                                    end % marca o fim da leitura de uma linha

                                    % Percorre as colunas para calcular os �ndices
                                    for m=1:n_col, 
                                        for l=1:n_lin,
                                            if mat_final(l,m) == 1;
                                                count_1 = count_1+1; %variavel auxiliar para contar a quantidade de 's na coluna
                                                espaco = 0;
                                                if l == n_lin, 
                                                    vet_indices_col_temp(l-1,m) = count_1; %verifica se o �ltimo elemento da coluna � 1 e atribui o n�mero de 1's � matriz com os indices
                                                    qtd_indices = qtd_indices +1; %quando chega na �ltima linha, se tiver um 1, incrementa a quantidade de �ndices na mesma itera��o
                                                end
                                            else
                                                if l == 1,  % verifica se o elemento � o primeiro da coluna, se for, armazena no mesma posi��o, caso contr�rio armazena numa posi��o anterior,
                                                            % isso � pra evitar que quando chegue na �ltima
                                                            % linha n�o haja espa�o para armazenar, pq o
                                                            % armazenamento s� ocorre ap�s a leitura do �ltimo
                                                            % 1 da sequ�ncia
                                                    vet_indices_lin_temp(l,m) = count_1;
                                                    if mat_final(l,m) == 0
                                                        qtd_indices = qtd_indices;  % verifca se o elemento anterior � zero, caso verdadeiro, mant�m a quantidade de �ndices para que esta
                                                                                    % s� seja incrementada ao final de uma sequ�ncia de 1's
                                                    end
                                                else 
                                                    vet_indices_col_temp(l-1,m) = count_1;
                                                    if mat_final(l-1,m) == 0
                                                            qtd_indices = qtd_indices;
                                                        else
                                                    qtd_indices = qtd_indices +1; % ap�s a leitura de todos os 1's incrementa a quantidade de ind�ces no primeiro 0 seguinte
                                                    end
                                                end
                                                count_1 = 0; % se o valor do elemento for 0 o contador � zerado
                                                qtd_indices = qtd_indices; % se o valor do elemento for igual a 0 mant�m a quantidade de �ndices
                                            end
                                        end
                                        % marca o fim da leitura de um elemento
                                        count_1 = 0;

                                        aptidao_col_temp = 100/qtd_indices; %define a aptid�o de cada grupo de 1's

                                        for l=1:n_lin, % percorre a coluna da matriz de �ndice correspondente para fazer a compara��o com os �ndices reais
                                            if vet_indices_col_temp(l,m) ~= 0, % Verifica se encontra um elemento diferente de zero na matriz que guarda os �ndices,
                                                                               % se encontrar incrementa
                                                                               % passou_indice para guardar
                                                                               % a ordem do �ndice (se o
                                                                               % primeiro ou o segundo)
                                                passou_indice = passou_indice + 1;
                                                if (passou_indice == 1 || passou_indice == 2) && (vet_indices_col_temp(l,m) == mat_col(m,passou_indice))
                                                        % verifica o �ndice com seu respectivo �ndice na matriz dos
                                                        % �ndices, respoeitando a ordem e se for igual atualiza a
                                                        % aptid�o da linha
                                                    aptidao_col = aptidao_col + aptidao_col_temp; % se o �ndice da matriz for igual ao �ndice real, a aptid�o da coluna � atualziada
                                                end
                                            else 
                                                passou_indice = passou_indice; % Se o elemento da matriz de �ndices for 0, mant�m o valor de passou_indice
                                                aptidao_col = aptidao_col; % Se o elemento da matriz de �ndices for 0, mant�m o valor da aptid�o da linha
                                            end
                                        end
                                        % marca o fim da leitura de um elemento
                                         vet_aptidao_col (1,m) = aptidao_col;
                                         aptidao_col = 0;
                                         passou_indice = 0;
                                         qtd_indices = 0;
                                    end % marca o fim da leitura de uma coluna

                                    % encontra a m�dia das aptidoes das linhas
                                    aptidao_lin_avg = mean(vet_aptidao_lin); 

                                    % encontra a m�dia das aptidoes das colunas
                                    aptidao_col_avg = mean(vet_aptidao_col); 

                                    % encontra a aptid�o da matriz tirando a m�dia entre as m�dias das aptid�es das linhas e das colunas
                                    aptidao_avg_final = (aptidao_lin_avg + aptidao_col_avg)/2;
                                    custo_final = 1/aptidao_avg_final;                            
                            end
                        else 
                            p_1 = rand(1);
                            if p_1 < p,
                                for i=1:n_lin,
                                    for j=1:n_col,
                                        mat_temp(i,j) = mat_vizinho(i,j);
                                    end        
                                end
                            end
                        end
                % ================================================================
                %                Atualizar T (temperatura corrente)
                % ================================================================    
                n_t = n_t - 1;
                iter = iter+1;
                vet_resultado_custo(1,iter) = custo_final;
                vet_resultado_aptidao(1,iter) = aptidao_avg_final;
            end
            k = k+1;
            t = alpha*t;
            %t = t/(1+(beta*t)); 
            %t = 1/(log10(1+k))
            n_ciclos = n_ciclos+1;
        end
        n_temperatura = n_temperatura + 1; 
        t_inicial = 2^(n_temperatura)
        vet_n_temperatura(1,n_temperatura) = t_inicial;
        vet_resultado_avg_aptidao(1,n_temperatura) = mean(vet_resultado_aptidao);
end

n_iteracoes = 1 : 1 : iter;
%subplot(2,1,1), plot(n_iteracoes,vet_resultado_custo);
%xlabel('n�mero de itera��es'); ylabel('custo de cada matriz');
%subplot(2,1,2),  plot(n_iteracoes,vet_resultado_aptidao);
%xlabel('n�mero de itera��es'); ylabel('aptid�o de cada matriz');
plot(vet_n_temperatura,vet_resultado_avg_aptidao);
xlabel('temperatura'); ylabel('aptid�o m�dia ');


