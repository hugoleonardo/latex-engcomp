function [ output_args ] = noise_reduction( imagem1, imagem2 )
%UNTITLED Summary of this function goes here
%   Noise reduciton as descrideb in the article

feature1 = imread(imagem1);
feature2 = imread(imagem2);
[M N] = size(feature1);
feature = zeros(M,N,2);

    
feature(:,:,1) = feature1;
feature(:,:,2) = feature2;

imshow(feature1);
figure
imshow(feature(:,:,2));
end

