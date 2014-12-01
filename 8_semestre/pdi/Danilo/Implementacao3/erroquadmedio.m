 function [ melhor_G, melhor_M, E ] = erroquadmedio( imagem, count )
%ERROQUADMEDIO Summary of this function goes here
%   Função usada na Questão 4 para ajustar os parâmetros dos filtros.
%   Recebe como entrada a imagem a ser processada.

    % Filtra as imagens utilizando filtros Gaussiano, de Mediana,
    % Estatístico e ajusta os parâmetros dos filtros de forma aleatória
    % (dentro de um dado intervalo)
    
    
    img = tomcinza(imagem);
    % Define um vetor com números aleatórios num detemrinado intervalo
        % e depois escolhe aleatoriamente um desses valores para ser o novo
        % valor da variável
        d = (round(normrnd(2:12,1)));
        d = d(1,round(rand(1)*10+1));
        
        sigma = (round(normrnd(2:12,1)));
        sigma = sigma(1,round(rand(1)*10+1));
    intervalo = 5; % Intervalo em torno da média do filtro gaussiano
    %count = 35; % Número de iterações
    [M N] = size(img);
    total_pxl = M*N;
    % N --> Armazena as imagens com ruído
    % G --> Armazena o resultado do filtro gaussiano
    % M --> Armazena o resultado do filtro de mediana
    % E --> Armazena o resultado do filtro estatístico
    
    % Armazena as imagens com ruído em uma matriz.
    N = geraruido(img);
    
    % Filtro Gaussiano (Escolhe uma das 20 imagens para realizar a filtragem)    
    %G = filtergauss(N(:,:,10), sigma,intervalo);
    % Filtro de Mediana (Escolhe uma das 20 imagens para realizar a filtragem)
    %M = filtermed(N(:,:,10),d,d); 
    % Filtro estatístico (média aritmética)
    E = filterest(N); % Filtro estatístico 
    
    % Calcula o erro quadrático médio do filtro gaussiano
    %erro_quad_gauss = calculaerro(img,G);
    %erro_quad_gauss = erro_quad_gauss/(total_pxl);
    % Calcula o erro quadrático médio do filtro de mediana
    %erro_quad_med = calculaerro(img,M);
    %erro_quad_med = erro_quad_med/(total_pxl);
    % Calcula o erro quadrático médio do filtro de mediana
    erro_quad_est = calculaerro(img,E)/(total_pxl);
    
%{
    while count > 0 %(erro_quad_gauss > erro_quad_est && erro_quad_med > erro_quad_est) && (sigma>1 && d>1 && intervalo>1)
        
        d = (round(normrnd(2:12,1)));
        d = d(1,round(rand(1)*10+1));
        
        sigma = (round(normrnd(2:12,1)));
        sigma = sigma(1,round(rand(1)*10+1));
        %intervalo = intervalo + 1;
        
        % Filtro Gaussiano (Escolhe uma das 20 imagens para realizar a filtragem)    
        G = filtergauss(N(:,:,10), sigma,intervalo);
        % Filtro de Mediana (Escolhe uma das 20 imagens para realizar a filtragem)
        M = filtermed(N(:,:,10),d,d); 
        
        % Filtro estatístico (média aritmética). É necessário calcular
        % apenas uma vez
        %img_est = filterest(N); % Filtro estatístico 
    
        % Calcula o erro quadrático médio do filtro gaussiano
        erro_quad_gauss_temp = erro_quad_gauss;
        erro_quad_gauss = calculaerro(img,G);
        erro_quad_gauss = erro_quad_gauss/(total_pxl);
         % Armazena o melhor resultado do filtro gaussiano para plotagem
        if erro_quad_gauss < erro_quad_gauss_temp 
            melhor_G = G;
            menor_erro_gauss = erro_quad_gauss;
            melhor_sigma = sigma;
        else
        end
        
        % Calcula o erro quadrático médio do filtro de mediana
        erro_quad_med_temp = erro_quad_med;
        erro_quad_med = calculaerro(img,M);
        erro_quad_med = erro_quad_med/(total_pxl);
         % Armazena o melhor resultado do filtro de mediana para plotagem
        if erro_quad_med < erro_quad_med_temp 
            melhor_M = M;
            menor_erro_med = erro_quad_med;
            melhor_d = d;
        else
        end
        
        % O erro estatístico é constante

        count = count - 1;

    end
    %}
    %str_gauss = sprintf('Imagem melhorada usando filtro Gaussiano com Desvio Padrão = %.1f e Intervalo = %.1f. Erro = %.10f', melhor_sigma, intervalo,menor_erro_gauss);
    %str_med = sprintf('Imagem melhorada usando filtro de Mediana com dimensões de %.1f x %.1f. Erro = %.10f', melhor_d,melhor_d,menor_erro_med);
    str_est = sprintf('Imagem melhorada usando filtro Estatístico. Erro = %.10f', erro_quad_est);
    subplot(2,1,1); image(img), colormap('gray'), title ('Imagem Original');
    %subplot(2,2,2); image(melhor_G), colormap('gray'), title(str_gauss);
    %subplot(2,2,3); image(melhor_M), colormap('gray'), title(str_med);    
    subplot(2,1,2); image(E), colormap('gray'), title(str_est); 
    
end

