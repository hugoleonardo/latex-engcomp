function [ feature ] = smoothing_danilo( imagem1, imagem2, window_size )
%UNTITLED Summary of this function goes here
%   Noise reduciton as descrideb in the article

D = 1;
feature1 = imread(imagem1);
feature2 = imread(imagem2);
feature1 = im2double(feature1);
feature2 = im2double(feature2);
[M N] = size(feature1);
feature = zeros(M-window_size,N-window_size);
%feature = zeros(M,N);
feature1_2 = zeros(M-window_size,N-window_size);
feature2_2 = zeros(M-window_size,N-window_size);

for i=round(window_size/2):M-(round(window_size/2)-1)
    for j=round(window_size/2):N-(round(window_size/2)-1)
        temp = 0;
        for m=1:window_size
            k = 0;
            for n=D:window_size
               k = k + 1;
               temp = (feature1(i-round(window_size/2)+m,k)*feature1(k,j-round(window_size/2)+n)) + temp;
            end
        end
        feature1_2(i,j) = temp;
    end
end

for i=round(window_size/2):M-(round(window_size/2)-1)
    for j=round(window_size/2):N-(round(window_size/2)-1)
        temp = 0;
        for m=1:window_size
            k = 0;
            for n=D:window_size
               k = k + 1;
               temp = (feature2(i-round(window_size/2)+m,k)*feature2(k,j-round(window_size/2)+n)) + temp;
            end
        end
        feature2_2(i,j) = temp;
    end
end
    

%{
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
%}
for i=round(window_size/2):M-(round(window_size/2)-1)
    for j=round(window_size/2):N-(round(window_size/2)-1)
        feature(i,j) = ((sqrt(2*(feature1_2(i,j)))) + ((sqrt(2*(feature2_2(i,j))))))/2;
    end
end

%feature = padarray(feature,[((round(window_size/2))) ((round(window_size/2)))],0,'both');

end

