%==========================================================================
% @desc Fazer a mutacao de algum dos filhos
%
% @param filhos         - Filhos gerados em decimal, vetor LINHA
% @param tamCromossomo  - Numero de bits maximo de um cromossomo
% @param taxaMutacao    - Taxa de mutacao
%==========================================================================
function result=mutacao(filhos, tamCromossomo, taxaMutacao);

    mutacao = roleta([taxaMutacao 100-taxaMutacao], 1);
    [nFilhos nJ] = size(filhos);
    filhos = dec2bin(filhos,tamCromossomo);
    
    % Aplicar a mutacao?
    if mutacao(1,1) == 1       
        % Escolher um filho para ser mutado
        mutante = floor(nFilhos * rand(1,1))+1;
        nBit = floor(tamCromossomo * rand(1,1))+1;
        bitAtual = filhos(mutante, nBit);
        
        % Fazer a mutacao em apenas um bit
        if bitAtual == dec2bin(1)
            bitMutante = dec2bin(0);
        else
            bitMutante = dec2bin(1);
        end
        
        % Alterando um bit no filho escolhido
        filhos(mutante, nBit) = bitMutante;
    end
    
    % Transformar de binario para decimal
    filhos = bin2dec(filhos);
    
    % Retorno da funcao
    result =filhos;

end