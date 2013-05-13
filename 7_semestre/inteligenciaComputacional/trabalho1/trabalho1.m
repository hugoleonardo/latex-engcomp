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
%POPULACAO INICIAL
npop = 20;

n_geracoes = 1+1;

n_torneio = 6;
torneio(n_torneio) = 0;
torneio_imelhores = [1:length(torneio); torneio];
aval_escolhidos(n_torneio)=0;

mean_aval(n_geracoes) = 0;
max_aval(n_geracoes) = 0;

ger_atual(npop,nlin,ncol) = 0;
prox_ger(npop,nlin,ncol)=0;
aval_ger(npop)=0;
aval_prox_ger(npop)=0;

peso(round(nlin/2))=0;
%Iniciando linhas
for n=1:npop,
    for i=1:nlin,
        %se tiver apenas um grupo de X deve alocar um indice considerando o
        %numero de Xs do grupo para nao extrapolar o numero de colunas
        if(matl(i,2) < 1)
            index(i,1) =  randi([1, ncol-matl(i,1)]+1);
            %preenche o unico grupo de Xs na matriz da linha i
            for x=index(i,1):(index(i,1)+matl(i,1)-1),
                ger_atual(n,i,x)=1;
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
            ger_atual(n,i,x)=1;
        end
        
        %preenche o segundo grupo de Xs na matriz da linha i
        for x=index(i,2):(index(i,2)+matl(i,2)-1),
            ger_atual(n,i,x)=1;
        end
    end
end

%achar matriz de pop
% k = squeeze(pop(1,:,:)) para a primeira matriz 2D
% k = squeeze(pop(2,:,:)) para a segunda matriz 2D
% vai ate o npop
geracao=1;
while(geracao < n_geracoes)
    %AVALIACAO
    
    %inicializando variaveis de controle
    for aux=1:npop,
        aval_ger(aux)=0;
        aval_prox_ger(aux)=0;
    end
    %aval_ger(npop) = 0;
    %aval_prox_ger(npop) = 0;
    %eh possivel haver no maximo 4 pesos em 8 linhas ou 5 em 9 linhas
    %o round arredonda pra mais
    for n=1:npop,
        %tmp = squeeze(pop(n,:,:))
        for j=1:ncol,
            %zera o contador de Xs a cada troca de coluna
            contador_x=0;
            %zera o contador de pesos a cada troca de coluna
            contador_peso=0;
            for i=1:nlin,
                %captura grupo de X com um unico X na ultima linha
                if(i==nlin && ger_atual(n,i,j)==1 && contador_x==0)
                    contador_peso=contador_peso+1;
                    peso(contador_peso)=1;
                    contador_x=0;
                    
                    %encontra X da coluna
                elseif(ger_atual(n,i,j)==1)
                    contador_x=contador_x+1;
                    
                    %se encontrar um vazio, checa se o contador saiu de
                    %zero para indicar se houve um grupo de Xs
                elseif(ger_atual(n,i,j)==0 && contador_x~=0)
                    %indica a existencia de um novo peso
                    contador_peso=contador_peso+1;
                    %guarda o novo peso no vetor de pesos
                    peso(contador_peso)=contador_x;
                    %zera o contador de Xs para encontrar o proximo grupo
                    contador_x=0;
                    %captura caso um grupo de X na ultima linha da coluna
                end
                
                %captura um grupo de X onde o ultimo elemento esta na
                %ultima linha da matriz
                if(contador_x>1 && i==nlin)
                    %indica a existencia de um novo peso
                    contador_peso=contador_peso+1;
                    %guarda o novo peso no vetor de pesos
                    peso(contador_peso)=contador_x;
                    %zera o contador de Xs para encontrar o proximo grupo
                    contador_x=0;
                end
            end
            
            %contador de numero de grupos de Xs corretos na coluna
            cont=0;
            %compara os grupos da solu��o com os da matriz atual
            for aux=1:2,
                %o diferente de zero serve para indicar quando a solucao
                %exige somente um grupo de X
                if(peso(aux)==matc(j,aux) && matc(j,aux)~=0)
                    cont=cont+1;
                end
            end
            
            %se o numero de pesos encontrados for menor que o numero de
            %pesos esperados, o contador de peso sera alterado para o
            %numero de pessoas esperados para que o calculo da taxa da
            %coluna seja calculada corretamente
            if(contador_peso<vet(j))
                contador_peso = vet(j);
            end
            
            %taxa parcial da matriz na coluna atual
            taxa_col = cont*(1/contador_peso);
            %taxa parcial normalizada da matriz na coluna atual
            taxa_col_n = taxa_col/ncol;
            %quando percorrer toda a matriz do individuo, sera calculada a
            %aptidao total deste individuo
            aval_ger(n) = aval_ger(n) + taxa_col_n;
            
            %zera o vetor de pesos a cada coluna
            for aux=1:(round(nlin/2)),
                peso(aux)=0;
            end
        end
    end
    %mean_aval_ger = mean(aval_ger);
    %max_aval_ger = max(aval_ger);
    
    mean_aval(geracao)= mean(aval_ger);
    max_aval(geracao)=max(aval_ger);
    
    %SELECAO
    %serao selecionados npop/2 individuos e armazenados em ger_prox
    %comeca do 2 porque ele sempre faz a leitura do individuo anterior
    n=2;
    aux=1;
    while(n<=npop)
        %escolha de indices aleatorios para o torneio
        for aux=1:n_torneio,
            torneio(aux)=randi([1,npop]);
            aval_escolhidos(aux) = aval_ger(torneio(aux));
        end
        
        %aval_escolhidos_ordenado eh um vetor que contem todos os
        %individuos do torneio ordenados em ordem descrescente
        
        %torneio_imelhores contem os indices de 1-n_torneio, o primeiro
        %indice indica qual indice de torneio contem a melhor avaliacao e
        %assim sucessivamente
        
        %aval_escolhidos contem as avaliacoes dos individuos sorteados na
        %mesma ordem que que eles foram sorteados
        
        %a partir das avaliacoes dos n_torneio individuos sorteados, eh
        %gerado um vetor com a ordem descrescente de avaliacao dos
        %individuos juntamente com um outro vetor que indica em seu
        %primeiro indice qual eh indice do vetor de entrada que foi
        %selecionado para ser o primeiro no vetor que contem a ordem
        %decrescente de avaliacao
        [aval_escolhidos_ordenado,torneio_imelhores] = sort(aval_escolhidos(:),'descend');
        
        %guarda os indices dos elementos de melhor avaliacao
        index_maior1 = torneio(torneio_imelhores(1));
        index_maior2 = torneio(torneio_imelhores(2));
        
        if(aval_ger(n-1) > aval_ger(n))
            prox_ger(aux,:,:)=squeeze(ger_atual(n-1,:,:));
        else
            prox_ger(aux,:,:)=squeeze(ger_atual(n,:,:));
        end
        aux=aux+1;
        n=n+2;
    end
    
    %crossover
    n=2;
    while(n<npop/2)
        %filho 1
        icros1 = randi([2,nlin]);
        %icros1=3;
        %filho tem a parte 1 do elemento n-1
        for i=1:(icros1-1),
            for j=1:ncol,
                prox_ger((npop/2+n),i,j)=prox_ger(n-1,i,j);
            end
        end
        %filho tem a parte 2 do elemento n
        for i=icros1:nlin,
            for j=1:ncol,
                prox_ger((npop/2+n),i,j)=prox_ger(n,i,j);
            end
        end
        
        %filho 2
        icros2 = randi([2,nlin]);
        %icros2=6;
        %filho tem a parte 1 do elemento n-1
        for i=1:(icros2-1),
            for j=1:ncol,
                prox_ger((npop/2+n+1),i,j)=prox_ger(n-1,i,j);
            end
        end
        %filho tem a parte 2 do elemento n
        for i=icros2:nlin,
            for j=1:ncol,
                prox_ger((npop/2+n+1),i,j)=prox_ger(n,i,j);
            end
        end
        
        n=n+2;
    end
    
    for n=1:npop,
        for i=1:nlin,
            for j=1:ncol,
                ger_atual(n,i,j)=prox_ger(n,i,j);
            end
        end
    end
    %ger_atual=prox_ger;
    geracao=geracao+1;
end



