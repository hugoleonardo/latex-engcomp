function [ new_img ] = filterest( imagem )
%FILTEREST Summary of this function goes here
%   Fun��o usada na quest�o 4 para a realiza��o da filtragem estat�stica de
%   da imagem de entrada

    %img = tomcinza(imagem);
    img = imagem;
   
    new_img = round(mean(img,3));

end

