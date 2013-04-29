% =========================================================================
%
% @desc Criar uma roleta viciada, para sorteio de numeros
%	As areas que sao passadas como entrada define a probabilidade
%	de uma certa area ser sorteada.
%
% @param area       - Vetor coluna com o percentual de cada area 
%                     ex.: [20 30 50]
% @param nJogadas   - numero de jogadas a serem simuladas
% @param result     - vetor com o numero de ocorrencias de sorteio em cada 
%                     area
%
% Paulo Eduardo Camboim de Brito
% 14/10/2010
% =========================================================================

function result=roleta(area, nJogadas);

% if ( (sum(area) > 100) || (sum(area)<100) )    
%     disp('O total da soma das entradas deve ser 100')
%     erro = 1;
%     result = erro;
%     return
% end

% Intervalo de cada area
[lin nArea] = size(area);
min = zeros(lin,nArea);
max = zeros(lin,nArea);

% Frequencia dos resultados em cada area
y = zeros(lin,nArea);

for i=1:nArea
    if(i == 1)
        min(i) = 1;
        max(i) = area(i);
    else
        min(i) = max(i-1) +1;
        max(i) = min(i)+area(i) -1;
    end    
end

% Deixar apenas a parte inteira
min = ceil(min);
max = ceil(max);

% Numero de jogadas a realizar
for i=1:nJogadas
    rodada = ceil(rand*100);
    
    % procurar no vetor de minimos
    for k=1:nArea
        if ( (rodada >= min(k)) && (rodada <= max(k)))
            y(k) = y(k)+1;
        end
    end
    
end

% Mostrando o resultado
result = y;