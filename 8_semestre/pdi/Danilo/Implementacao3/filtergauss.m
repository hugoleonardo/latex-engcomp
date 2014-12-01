function [ new_img ] = filtergauss( imagem, sigma,intervalo )
%FILTERGAUSS Summary of this function goes here

%   Fun��o para filtragem Gaussiana. Recebe como par�metro a imagem, o
%   desvio padr�o da fun��o gaussiana (sigma), e o intervalo desejado em
%   torno da m�dia.
%   Esta fun��o foi usada na quest�o 3
% ########## C�digo usado para repetir a quest�o 1 com o filtro Gaussiano ##########
%{
    % Cria o Filtro (filtro)
    filtro = fspecial('gaussian', intervalo*sigma ,sigma);
    % Define um impulso unit�tio [delta(0,0) = 1]
    T = 64; % Tamanho total do impulso
    imp = zeros(T,T);
    imp(T/2,T/2) = 1;
    % Calcula a resposta ao impulso do filtro [h(x,y)]
    h = conv2(filtro,imp);
    % Calcula a transformada de Fourier de h(x,y) = H(u,v) (Resposta em
    % frequ�ncia do filtro
    H = fftshift(h,512);
    freqz2(H,[512 512]);
    %[A f] = freqz2(H,[1 128]);
    
    % String para o plot da resposta em Frequ�ncia do filtro
    str_rf = sprintf('Resposta em Frequ�ncia para sigma = %f',sigma);
    % String para o plot da resposta ao Impulso do filtro
    str_ri = sprintf('Resposta ao Impulso para sigma = %f',sigma);
    %plot(f,10*log10(abs(A))), title (str_rf);
    figure;
    surf(h),title(str_ri);


%}

% ########## C�digo usado para repetir a quest�o 2 com o filtro Gaussiano (usado tamb�m na quest�o 4) ##########
    % Cria o filtro gaussiano
    %img = tomcinza(imagem);
    img = imagem;
    filtro = fspecial('gaussian', intervalo*sigma ,sigma);
    new_img = filter2(filtro,img);
    % String para o plot da Imagem Filtrada
    str = sprintf('Imagem Filtrada para sigma = %f',sigma);
    subplot(2,1,1);image(img), title('Imagem Original'), colormap('gray');
    subplot(2,1,2);image(new_img), title(str), colormap('gray');
%}
end

