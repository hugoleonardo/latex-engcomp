function [ gr ] = tomcinza(imagem)
%TOMCINZA Gera uma imagem em tom de cinza a aprtir das imagens RGB da
%imagem de entrada
%   Detailed explanation goes here

    img = imread(imagem);
    [M N C] = size(img);
    r = img(:,:,1); % Matriz Vermelha
    g = img(:,:,2); % Matriz Verde
    b = img(:,:,3); % Matriz Azul
    gr = [M N];     % Matriz para guardar os valores de cinza
    
    gr = round(mean(img,3));
    
    %image(gr), colorbar, title 'Gray';
    %figure;
    %image(r), colorbar, title 'Red';
    %figure;
    %image(g), colorbar, title 'Green';
    %figure;
    %image(b), colorbar, title 'Blue';

end

