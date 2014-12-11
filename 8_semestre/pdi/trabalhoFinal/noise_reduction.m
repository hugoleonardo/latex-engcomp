function [ feature ] = noise_reduction( imagem1, imagem2 )
%UNTITLED Summary of this function goes here
%   Noise reduciton as descrideb in the article

feature1 = imread(imagem1);
feature2 = imread(imagem2);
feature1 = im2double(feature1);
feature2 = im2double(feature2);
[M N] = size(feature1);
feature = zeros(M,N);
feature1_2 = zeros(M,N);
feature2_2 = zeros(M,N);

for i=1:M
    k = 0;
    for j=1:N
        k = k+1;
        feature1_2(i,j) = feature1(i,k)*feature1(k,j);
    end
end
for i=1:M
    k = 0;
    for j=1:N
        k = k+1;
        feature2_2(i,j) = feature2(i,k)*feature2(k,j);
    end
end
for i=1:M
    for j=1:N
        feature(i,j) = (sqrt(feature1_2(i,j)*2) + sqrt(feature2_2(i,j)*2))/2;
    end
end
   

end

