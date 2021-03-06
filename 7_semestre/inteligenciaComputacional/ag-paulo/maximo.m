% =========================================================================
% @desc Algoritmo genetico para encontrar um maximo de uma funcao
%
%
% floor(N * rand(4,1))+1 = rand de 1 at� N
% =========================================================================
function result=maximo();

    clear all;
    clc;

    % =====================================================================
    % Configuracoes iniciais
    tamCromossomo = 5;

    taxaCross   = 80;
    taxaMutacao = 1;

    iteracaoAtual = 1;
    iteracaoTotal = 100;

    % PASSO 1 - GERAR A POPULACAO INICIAL
    % =====================================================================
    % Inicializar populacao e transformar em binario (cromossomo com 5 bits)

    populacao = [25, 15, 14, 10]';
    %cromossomos = dec2bin(populacao,tamCromossomo);
    [iPopulacao jPopulacao] = size(populacao);

    % PASSO 2 - AVALIAR CADA INDIVIDUO DA POPULACAO
    % =====================================================================
    % Avaliar populacao

    probSelecao = aptidao(populacao);

    % PASSO 3 - ENQUANTO O CRITERIO DE PARADA NAO FOR SATISFEITO FAZER
    % =====================================================================
    while iteracaoAtual < iteracaoTotal

        % PASSO 3.1 - SELECIONAR OS INDIVIDUOS MAIS APTOS
        % =================================================================

        % Gerar o numero de filhos igual a populacao anterior
        k = 1;
        while k <= iPopulacao
            % Selecionar o casal
            pai1 = selecao(populacao,probSelecao);
            pai2 = selecao(populacao,probSelecao);

            % PASSO 3.1 - CROSSOVER
            % =============================================================
            nFilhos     = 2;
            filhos(k:k+1,:) = crossover(pai1, pai2, nFilhos, tamCromossomo, taxaCross);

            % Contar dois, pois cada casal tem dois filhos
            k = k+2;
        end

        % PASSO 3.1 - MUTACAO
        % =================================================================

        filhos = mutacao(filhos, tamCromossomo, taxaMutacao);

        % FIM DE PASSO 3.1
        % =================================================================
        
        % ELITISMO
        % =================================================================
        elitePopulacao  = max(populacao);
        eliteFilhos     = max(filhos);
        if elitePopulacao > eliteFilhos
            [nMenor, iMenor] = min(filhos);
            filhos(iMenor,1) = elitePopulacao;
        end
        
        % FIM DE ELITISMO
        % =================================================================
        
        % A nova populacao eh igual aos filhos gerados
        populacao = filhos;

        % Incrementar o numero de iteracao ateh chegar ao total
        iteracaoAtual = iteracaoAtual + 1;
        
    end
    
    result = filhos;
end
