function [ new_img ] = filter2d( imagem, L )
%FILTER2D Summary of this function goes here
%   Fun��o para filtragem 2D. Recebe como par�metro a imagem e o tamanho da Janela do filtro (L).
%   Esta fun��o foi usada nas quest�es 1 e 2

% ############## C�digo usado na Quest�o 1 ##############  
%{ 
   img = tomcinza(imagem);
    % Cria o Filtro (filtro)
    filtro = ones(L,L)/(L*L);
    % Define um impulso unit�tio [delta(0,0) = 1]
    T = 64; % Tamanho total do impulso
    imp = zeros(T,T);
    imp(T/2,T/2) = 1;
    % Calcula a resposta ao impulso do filtro [h(x,y)]
    h = conv2(filtro,imp);
    % Calcula a transformada de Fourier de h(x,y) = H(u,v) (Resposta em
    % frequ�ncia do filtro
    H = fftshift(h,128);
    % freqz2(H,[128 128]);
    [A f] = freqz2(H,[1 128]);
    
    % String para o plot da resposta em Frequ�ncia do filtro
    str_rf = sprintf('Resposta em Frequ�ncia para L = %f',L);
    % String para o plot da resposta ao Impulso do filtro
    str_ri = sprintf('Resposta ao Impulso para L = %f',L);
    plot(f,10*log10(abs(A))), title (str_rf);
    figure;
    surf(h),title(str_ri);
    %}
% ############## C�digo usado na Quest�o 2 ############## 
    %img = tomcinza(imagem);
    img = imagem;
    % Cria o Filtro (filtro)
    filtro = ones(L,L)/(L*L);
    new_img = filter2(filtro,img);
    % String para o plot da Imagem Filtrada
    %str = sprintf('Imagem Filtrada para L = %.1f',L);
    %subplot(2,1,1);image(img), title('Imagem Original'), colormap('gray');
    %subplot(2,1,2);image(new_img), title(str), colormap('gray');
end

