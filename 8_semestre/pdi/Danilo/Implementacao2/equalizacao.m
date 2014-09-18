function [ n_pixels ] = equalizacao( imagem )
%EQUALIZACAO Summary of this function goes here
%   A imagem equalizada foi calculada usando a seguinte função de
%   distribuição: Y = (FAxi*255)/Pt
%   Onde FAxi é a frequência acumulado para o pixel 'i'
%   Pt é o número total de pixels da imagem

    int = 1:256;
    gray_image = tomcinza(imagem);
    n_pixels = histograma(gray_image); % Vetor que guarda a frequência dos pixels da imagem original
    [M N] = size(gray_image);
    p_total = M*N; % Número total de pixels
    n_pixels_ideal(1,256) = 0;
    n_pixels_acum = histacum(gray_image); % Vetor que guarda a frequência acumulada dos pixels da imagem original
    gray_image_eq(M,N) = 0;
    % Gera o vetor do histograma ideal para a imagem
    for i=1:256
        n_pixels_ideal(1,i) = i;
    end
    
    %Calcula os valores da imagem equalizada
    for i=1:M
        for j=1:N
            gray_image_eq(i,j) = (n_pixels_acum(1,gray_image(i,j)+1)*255)/p_total;
        end
    end
    n_pixels_eq = histograma(gray_image_eq); % Vetor que guarda a frequência dos pixels da imagem equalizada
    n_pixels_eq_acum = histacum(gray_image_eq); % Vetor que guarda a frequência acumulada dos pixels da imagem equalizada



    subplot(2,2,1); bar(int,n_pixels),title('Histograma da imagem de refrência');
    subplot(2,2,2); bar(int,n_pixels_acum),title('Histograma Acumulado da imagem de refrência');
    subplot(2,2,3); bar(int,n_pixels_eq),title('Histograma da imagem equalizada');
    subplot(2,2,4); bar(int,n_pixels_eq_acum),title('Histograma Acumulado da imagem equalizada');
    figure;
    subplot(1,2,1); image(gray_image), colormap(gray), title('Imagem original');
    subplot(1,2,2); image(gray_image_eq), colormap(gray), title('Imagem equalizada');


end

