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
matl =[3,0; 2,1; 3,2; 2,2; 6,0; 1,5; 6,0; 1,0; 2,0];
%colunas
ncol = 8;
matc =[1,2; 3,1; 1,5; 7,1; 5,0; 3,0; 4,0; 3,0];
vet = [2;2;2;2;1;1;1;1];

%###### AJUSTES #######
npop = 500;
n_geracoes = 50+1;
pressao_torneio = 3;
taxa_crossover = 0.75;
taxa_mutacao = 0.1;

%POPULACAO INICIAL
index_escolhidos(npop/2)=0;
torneio(pressao_torneio) = 0;
torneio_imelhores = [1:length(torneio); torneio];
aval_escolhidos(pressao_torneio)=0;
min_aval(n_geracoes) = 0;
mean_aval(n_geracoes) = 0;
max_aval(n_geracoes) = 0;
ger_atual(npop,nlin,ncol) = 0;
prox_ger(npop,nlin,ncol)=0;
aval_ger(npop)=0;

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
        %aval_prox_ger(aux)=0;
    end
    
    %inicializando variaveis de controle
    %eh possivel haver no maximo 4 pesos em 8 linhas ou 5 em 9 linhas
    %o round arredonda pra mais
    for n=1:npop,
        %squeeze(ger_atual(n,:,:))
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
            %compara os grupos da solução com os da matriz atual
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
    
    min_aval(geracao)= min(aval_ger);
    mean_aval(geracao)= mean(aval_ger);
    max_aval(geracao)= max(aval_ger);
    
    
    
    %SELECAO
    n=1;
    while(n<=npop/2)
        %escolha de indices aleatorios para o torneio
        for aux=1:pressao_torneio,
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
        index_maior3 = torneio(torneio_imelhores(3));
        
        %ajuda a manter a diversidade
        %pega o melhor do torneio caso ainda nao tenha sido escolhido
        if(any(index_escolhidos ~= index_maior1))
            index_escolhidos(n) = index_maior1;
            prox_ger(n,:,:) = squeeze(ger_atual(index_maior1,:,:));
            n=n+1;
            %pega o segundo melhor do torneio caso ainda nao tenha sido escolhido
        elseif(any(index_escolhidos ~= indexmaior2))
            index_escolhidos(n) = index_maior2;
            prox_ger(n,:,:) = squeeze(ger_atual(index_maior2,:,:));
            n=n+1;
            %pega o terceiro melhor do torneio caso ainda nao tenha sido escolhido
        elseif(any(index_escolhidos ~= indexmaior3))
            index_escolhidos(n) = index_maior3;
            prox_ger(n,:,:) = squeeze(ger_atual(index_maior3,:,:));
            n=n+1;
        end
    end
    
    %REPRODUCAO
    n=1;
    while(n<=npop/2)
        pai1 = randi([1,npop/2]);
        pai2 = pai1;
        %garante que o pai seja diferente do pai2
        while(pai1 == pai2)
            pai2 = randi([1,npop/2]);
        end
        
        %determina se o cruzamento vai ou nao acontecer
        if(rand > taxa_crossover)
            continue;
        end
        
        %ponto de crossover
        pcros = randi([2,nlin]);
        
        %parte 1 vem do pai1
        if(rand > 0.5)
            for i=1:(pcros-1),
                for j=1:ncol,
                    prox_ger((npop/2+n),i,j)=prox_ger(pai1,i,j);
                end
            end
            %filho tem a parte 2 do elemento n
            for i=pcros:nlin,
                for j=1:ncol,
                    prox_ger((npop/2+n),i,j)=prox_ger(pai2,i,j);
                end
            end
            %parte 1 vem do pai2
        else
            for i=1:(pcros-1),
                for j=1:ncol,
                    prox_ger((npop/2+n),i,j)=prox_ger(pai2,i,j);
                end
            end
            %filho tem a parte 2 do elemento n
            for i=pcros:nlin,
                for j=1:ncol,
                    prox_ger((npop/2+n),i,j)=prox_ger(pai1,i,j);
                end
            end
        end
        n=n+1;
    end
    
    for n=1:npop,
        aval_ger(n)=0;
        for i=1:nlin,
            for j=1:ncol,
                ger_atual(n,i,j)=prox_ger(n,i,j);
            end
        end
    end
    
    geracao=geracao+1;
    
    %continue;
    %MUTACAO
    for n=1:npop,
        %escolher a linha e o individuo para a mutação
        linha_mut = randi([1,nlin]);
        individuo_mut = n;
        if(rand < taxa_mutacao)
            flag_mut = false;
            aux_mut(ncol) = 0;
            index_mut(2) = 0;
            parte_mut = 0;
            verificador_mut = 0;
            %tmp = squeeze(pop(n,:,:))
            %zera o contador de Xs a cada troca de coluna
            contador_x_mut=0;
            %zera o contador de pesos a cada troca de coluna
            contador_peso_mut=0;
            for i=1:ncol,
                %captura grupo de X com um unico X na ultima linha
                
                if(i==ncol && ger_atual(n,linha_mut,i)==1 && contador_x_mut==0)
                    contador_peso_mut=contador_peso_mut+1;
                    peso_mut(contador_peso_mut)=1;
                    contador_x_mut=0;
                    
                    %encontra X da coluna
                elseif(ger_atual(n,linha_mut,i)==1)
                    contador_x_mut=contador_x_mut+1;
                    
                    %se encontrar um vazio, checa se o contador saiu de
                    %zero para indicar se houve um grupo de Xs
                elseif(ger_atual(n,linha_mut,i)==0 && contador_x_mut~=0)
                    %indica a existencia de um novo peso
                    contador_peso_mut=contador_peso_mut+1;
                    %guarda o novo peso no vetor de pesos
                    peso_mut(contador_peso_mut)=contador_x_mut;
                    %zera o contador de Xs para encontrar o proximo grupo
                    contador_x_mut=0;
                    %captura caso um grupo de X na ultima linha da coluna
                end
                
                %captura um grupo de X onde o ultimo elemento esta na
                %ultima linha da matriz
                if(contador_x_mut>1 && i==ncol)
                    %indica a existencia de um novo peso
                    contador_peso_mut=contador_peso_mut+1;
                    %guarda o novo peso no vetor de pesos
                    peso_mut(contador_peso_mut)=contador_x_mut;
                    %zera o contador de Xs para encontrar o proximo grupo
                    contador_x_mut=0;
                end
            end
            peso_selecionado_mut = randi([1,contador_peso_mut]);
            %mapeamento para a mutação
            for i=1:ncol,
                if(ger_atual(n,linha_mut,i)==1 && i==1)
                    aux_mut(i) = 1;
                    flag_mut = true;
                    parte_mut = parte_mut+1;
                    if(parte_mut==peso_selecionado_mut)
                        index_mut(1) = 1;
                    end
                end
                
                if(ger_atual(n,linha_mut,i)==1)
                    if(flag_mut~=true)
                        parte_mut = parte_mut+1;
                        flag_mut = true;
                        if(parte_mut==peso_selecionado_mut)
                            index_mut(1) = i;
                        end
                    end
                    if(contador_peso_mut>1 && parte_mut~=peso_selecionado_mut && i~=1)
                        if(aux_mut(i-1)==0)
                            aux_mut(i-1)=2;
                        end
                    end
                    aux_mut(i) = 1;
                    if(i==ncol && parte_mut==peso_selecionado_mut)
                        index_mut(2) = i;
                    end
                end
                
                if(ger_atual(n,linha_mut,i)==0)
                    aux_mut(i) = 0;
                end
                
                if(ger_atual(n,linha_mut,i)==0 && flag_mut==true)
                    if(parte_mut~=peso_selecionado_mut)
                        aux_mut(i) = 2;
                    end
                    if(parte_mut==peso_selecionado_mut)
                        index_mut(2) = i-1;
                    end
                    flag_mut = false;
                end
            end
            %esquerda = 1 e direita = 2
            left_or_right_mut = randi(1:2);
            casas_mut = randi([1,ncol - sum(peso_mut)]);
            
            %mutação para a esquerda
            if(left_or_right_mut == 1)
                while(casas_mut>1)
                    if(index_mut(1)-casas_mut<1)
                        casas_mut = casas_mut-1;
                    else
                        for i=index_mut(1)-casas_mut:index_mut(1)-1
                            verificador_mut = aux_mut(i)+verificador_mut;
                        end
                        if(verificador_mut==0)
                            for i=index_mut(1)-casas_mut:index_mut(1)-1
                                aux_mut(i) = 1;
                            end
                            for i=index_mut(2)-casas_mut+1:index_mut(2)
                                aux_mut(i)=0;
                            end
                            casas_mut = 0;
                        else
                            casas_mut = casas_mut-1;
                        end
                    end
                end
                %mutação para direita
            else
                while(casas_mut>1)
                    if(index_mut(2)+casas_mut>ncol)
                        casas_mut = casas_mut-1;
                    else
                        for i=index_mut(2)+1:index_mut(2)+casas_mut
                            verificador_mut = aux_mut(i)+verificador_mut;
                        end
                        if(verificador_mut==0)
                            for i=index_mut(2)+1:index_mut(2)+casas_mut
                                aux_mut(i) = 1;
                            end
                            for i=index_mut(1):index_mut(1)+casas_mut-1
                                aux_mut(i)=0;
                            end
                            casas_mut = 0;
                        else
                            casas_mut = casas_mut-1;
                        end
                    end
                end
            end
            %zera o vetor de usos a cada coluna
            for aux=1:(round(ncol/2)),
                peso_mut(aux)=0;
            end
            for j=1:ncol,
                if(aux_mut(j)==2)
                aux_mut(j)=0;
                end
                ger_atual(n,linha_mut,j) = aux_mut(j);
            end
        end
    end
    
  
end



