function [ new_img ] = filterest( imagem )
%FILTEREST Summary of this function goes here
%   Função usada na questão 4 para a realização da filtragem estatística de
%   da imagem de entrada

    %img = tomcinza(imagem);
    img = imagem;
   
    new_img = round(mean(img,3));

end

