%==========================================================================
% @desc Faz a selecao do individuo mais apto
%
% @param individuos - Individuos de uma populacao em um vetor LINHA
% @param pi         - Probabilidadde de selecao proporcional a aptidao
% @obs              - Caso usar pi=0 indicia o uso de selecao por torneio
%==========================================================================
function result=selecao(populacao, probSelecao);

    % Selecao por Torneio
    if pi == 0
        
    % Selecao por Roleta
    else
        resp = roleta(probSelecao',1);
        selecionado = find(resp);
        
    end
    
    % Retorna o resultado
    result = populacao(selecionado,1);

end