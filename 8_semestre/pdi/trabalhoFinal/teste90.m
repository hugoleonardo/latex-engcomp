function [ img_novo ] = teste90( imagem)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    img = imagem %imread(imagem);
    [m,n] = size(img);
    img_novo = zeros(m,n);
    for i=1:m
        for j=1:n
            if img(i,j) == 1
                img_novo(i,j) = 55;
            elseif img(i,j) == 2
                img_novo(i,j) = 99;
                elseif img(i,j) == 3
                    img_novo(i,j) = 147;
                    elseif img(i,j) == 4
                    img_novo(i,j) = 211;
                        elseif img(i,j) == 5
                         img_novo(i,j) = 245;
            end
        end
    end
    imshow(img_novo,[]);
    
    imwrite(img_novo, 'mosaic3_clusterizacao11.png');

end

