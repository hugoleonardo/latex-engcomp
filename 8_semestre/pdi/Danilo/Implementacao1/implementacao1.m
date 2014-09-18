function [  ] = implementacao1( imagem )

    f = imread(imagem);
    imshow(f);
    imwrite(f,'imagem_nova.jpg');

end

