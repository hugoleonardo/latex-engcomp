function [ imagem_tresh ] = segmenta( imagem_norm, M, N, treshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

imagem_tresh(M,N) = 0;

for i=1:M
    for j=1:N
        if imagem_norm(i,j) > treshold && imagem_norm(i,j) ~= 0;
        imagem_tresh(i,j) = 255;
        else if imagem_norm(i,j) == 0
        imagem_tresh(i,j) = 0;
            else
                imagem_norm(i,j) = 0;
            end
        end
    end
end



end

