function [ new_img ] = filtermed( imagem, d1,d2 )
%FILTERMED Summary of this function goes here
%   Função usada na questão 5 para o cálculo da imagem usando o filtro da
%   mediana

    img = imagem;
    new_img = medfilt2(img, [d1 d2]);
    

end

