function [ n_pixels_acum ] = histacum( imagem )
%HISTACUM Calcula o histograma acumulado da imagem de entrada (em tom de
%cinza)
%   Detailed explanation goes here

    n_pixels_acum(1,256) = 0;
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
    
    for i=1:256
        if i==1
            n_pixels_acum(1,i) = n_pixels(1,i);
        else
            n_pixels_acum(1,i) = n_pixels(1,i)+n_pixels_acum(1,i-1);
        end
    end
        
    %bar(int,n_pixels_acum);


end

