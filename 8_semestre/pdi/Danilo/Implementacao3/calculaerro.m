function [ erro ] = calculaerro( imagem_orig, imagem_filt )
%CALCULAERRO Summary of this function goes here
%   Função usada na Questão 4 para calcular o erro quadrático médio

    [M N] = size(imagem_orig);
   
    temp = imagem_orig - imagem_filt;
    temp = temp.^2;
    temp = sum(sum(temp));
    erro = temp/(M*N);

end

