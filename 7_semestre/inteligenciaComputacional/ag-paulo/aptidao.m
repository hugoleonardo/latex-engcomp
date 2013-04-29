%==========================================================================
% @desc Calcula a aptidão 
%==========================================================================
function result=aptidao(populacao);

    % Numero da populacao
    [iTotal,jTotal] = size(populacao);

    % Calcular o f(x) de cada entrada
    for i=1:iTotal     
        k = 1;    
        for j=1:jTotal     
            % Cada elemento da populacao inicial
            x = populacao(i,j);

            % Funcao objetivo
            f(i,k) = x^2;        
            k = k+1;
        end
    end

    % Calcular a aptidao
    pi = (f / sum(f)) * 100;

    % Retorno da funcao
    result =pi;

end

