function [ new_image_gama1, new_image_gama2 ] = transfint(imagem, gama1, gama2)
%TRANSFINT: Função de transformação de Intensidade
%   Para que a imagem de saída mantenha o intervalo [0,255],
%   O valor de k usado foi: k = 1/(255^(gama-1))

    gray_image = tomcinza(imagem);
    [M N] = size(gray_image);
    int = 1:256;
    k1 = 1/(255^(gama1-1));
    k2 = 1/(255^(gama2-1));
    new_image_gama1(M,N) = 0;
    new_image_gama2(M,N) = 0;
    valores_mapeados_gama1(1,256) = 0;
    valores_mapeados_gama2(1,256) = 0;
    for i=1:M
        for j=1:N
            new_image_gama1(i,j) = k1*((gray_image(i,j))^gama1);
            if valores_mapeados_gama1(1,gray_image(i,j)+1) ~= 0
                
            else
                valores_mapeados_gama1(1,gray_image(i,j)+1) = new_image_gama1(i,j);
            end
        end
    end
    
    for i=1:M
        for j=1:N
            new_image_gama2(i,j) = k2*((gray_image(i,j))^gama2);
            if valores_mapeados_gama2(1,gray_image(i,j)+1) ~= 0
                
            else
                valores_mapeados_gama2(1,gray_image(i,j)+1) = new_image_gama2(i,j);
            end
        end
    end
   
    n_pixels_ref = histograma(gray_image); % Guarda o vetor com o número de pixels para cada valor de pixel da imagem de referência
    n_pixels_res_gama1 = histograma(new_image_gama1); % Guarda o vetor com o número de pixels para cada valor de pixel da imagem resultante
    n_pixels_res_gama2 = histograma(new_image_gama2); % Guarda o vetor com o número de pixels para cada valor de pixel da imagem resultante
    
    subplot(3,2,1);image(gray_image); colormap(gray), title('Imagem de Refrência');
    subplot(3,2,2);bar(int,n_pixels_ref), title('Histograma da imagem de Referência');
    subplot(3,2,3);image(new_image_gama1); colormap(gray), title('Imagem Resultante - Gama 1');
    subplot(3,2,4);bar(int,n_pixels_res_gama1), title('Histograma da imagem Resultante - Gama 1');
    subplot(3,2,5);image(new_image_gama2); colormap(gray), title('Imagem Resultante - Gama 2');
    subplot(3,2,6);bar(int,n_pixels_res_gama2), title('Histograma da imagem Resultante - Gama2');
    figure;
    plot(int,valores_mapeados_gama1,'b',int,valores_mapeados_gama2,'r'), legend('Gama 1','Gama 2','Location','northwest');
end

