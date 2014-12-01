function [ erro ] = calculaerro( imagem_orig, imagem_filt )
%CALCULAERRO Summary of this function goes here
%   Fun��o usada na Quest�o 4 para calcular o erro quadr�tico m�dio

    [M N] = size(imagem_orig);
   
    temp = imagem_orig - imagem_filt;
    temp = temp.^2;
    temp = sum(sum(temp));
    erro = temp/(M*N);

end

