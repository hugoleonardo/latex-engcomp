function [ imagem_norm ] = normaliza( imagem, M, N )
%UNTITLED2 Summary of this function goes here
%   Fun��o que normaliza entre 0 e 1 os valores da imagem ap�s a extra��o
%   da caracter�stica. Esta fun��o tamb�m preenche os espa�os em bracos
%   dexados pela janela na borda da imagem

% Normalizing the GLCM contrast matrix 
imagem_min = min(min(imagem));
imagem_max = max(max(imagem));
imagem_norm (M,N) = 0;
for i=1:M
    for j=1:N
        imagem_norm(i,j) = (imagem(i,j)-imagem_min)/(imagem_max-imagem_min);
    end
end
% Filling in the blank spaces caused by the window

%imagem_norm = padarray(imagem_norm,[((round(window_size/2))) ((round(window_size/2)))],0,'both');




end

