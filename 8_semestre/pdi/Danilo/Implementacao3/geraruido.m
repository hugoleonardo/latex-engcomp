function [ noisy_images ] = geraruido( imagem )
%GERARUIDO Summary of this function goes here
%   Fun��o utilizada na Quest�o 4 para gerar as 20 imagens com ruido
%   Gaussiano com SNR = 5db
%   Recebe como entrada a imagem a ser processada.
    %img = tomcinza(imagem);
    img = imagem;
    [M N] = size(img);
    % sigma =  Desvio padr�o usado no filtro gaussiano
    
    noisy_images(M,N,20) = 0;
    for k=1:20
        noisy_images(:,:,k) = awgn(img, 5,'measured');
    end
        
    
    
    %str_gauss = sprintf('Imagem melhorada usando filtro Gaussiano com Desvio = %.1f', sigma);
    %tr_med = sprintf('Imagem melhorada usando filtro de Mediana com dimens�es de %.1f x %.1f', d1,d2);
    %str_est = sprintf('Imagem melhorada usando filtro Estat�stico');
    %subplot(2,2,1); image(img), colormap('gray'), title ('Imagem Original');
    %subplot(2,2,2); image(img_gauss), colormap('gray'), title(str_gauss);
    %subplot(2,2,3); image(img_med), colormap('gray'), title(str_med);    
    %subplot(2,2,4); image(img_est), colormap('gray'), title(str_est);    

end

