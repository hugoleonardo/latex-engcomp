function [ new_img, img_uni, img_med ] = salpimenta( imagem, percent, L, d )
%SALPIMENTA Recebe como entrada a imagem (em tom de cinza) a ser corrompida, o percentual de
%pixels a serem corrompidos, o tamanho da janela do filtro 2D e as
%dimensões do filtro de mediana (para este caso será sempre uma matriz
%quadrada)

%   Função utilizada na Questão 5 para adição de ruído do tipo sal e
%   pimenta na imagem de entrada

    img = tomcinza(imagem);
    %L = 3; % Janela do filtro 2D
    d1 = d; d2 = d; % Dimensões do filtro de mediana
    % Vetor com valores inteiros no intervalo [230,255]
    vet_sal = round(normrnd(231:255,1));
    
    % Valor aleatório que define o índice do vetor
    % que irá definir o novo valor do pixel
    temp_pepper = round(rand(1)*25); 
    
    % Vetor com valores inteiros no intervalo [230,255]
    vet_pepper = round(normrnd(1:25,1));
    
    % Valor aleatório que define o índice do vetor
    % que irá definir o novo valor do pixel
    temp_pepper = round(rand(1)*25); 
    
    [M N] = size(img); % Tamanho da imagem
    new_img = img; % Atribui a nova imagem sendo igual a imagem original,
    % para que apenas os valores dos pixels aleatoriamente escolhidos para
    % o ruído sejam alterados, deixando o resto da imagem inalterada.
    
    
    p = percent/100; % Probabilidade de um pixel estar corrompido
    count_sal = 0; % Contador para contar a quantidade de pixels já corrompidos (tipo sal)
    count_pepper = 0; % Contador para contar a quantidade de pixels já corrompidos (tipo pimenta)
    fator = (percent*(M*N))/100; % Fator que indica o número máximo de pixels corrompidos

    while count_sal < fator/2 && count_pepper < fator/2 % Garante que o ruído só pare de ser adicionado
                                                        % quando a
                                                        % quantidade de
                                                        % pixels
                                                        % corrompidos por
                                                        % sal e pimenta
                                                        % forem iguais
        % Faz o sorteio de um pixel aleatório para verificar se ele vai ou
        % não ser corrompido. Este processo é repetido até que o eprcentual
        % desejado de pixels seja corrompido
        i = round(rand(1)*M)+1;
        j = round(rand(1)*N)+1;
        if (count_sal + count_pepper) < fator % Adiciona o ruído
            if rand(1) <= p/2 % Ruído tipo sal
                vet_sal = round(normrnd(231:255,1));
                temp_sal = round(rand(1)*24)+1;
                new_img(i,j) = vet_sal(1,temp_sal);
                count_sal = count_sal+1;
            else   % Ruído tipo pimenta
                vet_pepper = round(normrnd(1:25,1));
                temp_pepper = round(rand(1)*24)+1;
                new_img(i,j) = vet_pepper(1,temp_pepper);
                count_pepper = count_pepper+1;
            end
        else
            % Nada acontece
        end
    end
    
    
    img_uni = filter2d(new_img,L); % Filtro 2D Uniforme
    img_med = filtermed(new_img,d1,d2); % Filtro de Mediana
    str_ruido = sprintf('Imagem degradada pelo ruído sal e pimenta com %.1f%% de pixels corrompidos (b)' , percent);
    str_uni = sprintf('Imagem melhorada com filtro 2D Uniforme (L = %.1f) com %.1f%% de pixels corrompidos (c)' , L, percent);
    str_med = sprintf('Imagem melhorada com filtro de Mediana (Dimensões de %.1f x %.1f) com %.1f%%  de pixels corrompidos (d)' , d1, d2, percent);
    subplot(2,2,1); image(img), colormap('gray'), title('Imagem original (a)');
    subplot(2,2,2); image(new_img), colormap('gray'), title(str_ruido);
    subplot(2,2,3); image(img_uni), colormap('gray'), title(str_uni);
    subplot(2,2,4); image(img_med), colormap('gray'), title(str_med);
        
    %subplot(1,2,1); image(img_uni), colormap('gray'), title(str_uni);
    %subplot(1,2,2); image(img_med), colormap('gray'), title(str_med);
    
end

