function [ n_pixels ] = histograma( imagem )
%HISTOGRAMA Cálculo do histograma da imagem de entrada (em tom de cinza)
%   Detailed explanation goes here

    n_pixels(1,256) = 0;
    int = 1:256;
    gray_image =  imagem; %tomcinza(imagem);
    [M N] = size(gray_image);
    for i=1:M
        for j=1:N
            temp = round(gray_image(i,j));
            n_pixels(temp+1) = n_pixels(temp+1)+1;
        end
    end

    %bar(int,n_pixels);
end

