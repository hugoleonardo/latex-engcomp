function [ feature, feature_s ] = smoothing_danilo( imagem1, imagem2, window_size )
%UNTITLED Summary of this function goes here
%   Noise reduciton as descrideb in the article

feature1 = imread(imagem1);
feature2 = imread(imagem2);
[M N] = size(feature1);
%feature = zeros(M,N);

feature1 = feature1.*feature1;
feature2 = feature2.*feature2;

feature1 = normaliza(feature1, M, N, window_size);
feature2 = normaliza(feature2, M, N, window_size);

feature = (sqrt(2*feature1) + sqrt(2*feature2))/2;

feature_s = filter2d(feature,window_size);

end

