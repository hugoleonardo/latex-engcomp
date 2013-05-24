% (nome do arquivo: FSexp_a.m)
% Este exemplo mostra como calcular, numericamente
% Coeficiente Dn da série de Fourier exponencial
% diretamente
% O usuário  deve definir uma função simbólica
% g(t). Neste exemplo, g(t) = funct_tri(t).
echo off; clear; clf;

j = sqrt(-1); % Define j para álgebra complexa
b=2; a=-2; % Definição de um período do sinal
tol = 1.e-5; % Especificação da tolerância para erro de integração
T = b-a; % comprimento de um período
N = 11; % Número de componentes da série de Fourier

Fi = [-N,N]*2*pi/T % Especificação do intervalo de frequeências
% D_0 é calculado e armazenado em D(N+1);
Func = @(t) funct_tri(t/2);
D(N+1) = 1/T*quad(Func,a,b,tol); % A função quad do MatLab usada para o cálculo da integral

for i=1:N
    % Dn é calculado, para  n=1,...,n=N, e armazenado em D(n+2)...
    Func = @(t) exp (-j*2*pi*t*i/T).*funct_tri(t/2)
    D(i+N+1) = quad(Func,a,b,tol)
    % Dn pe calculado, para n = -N,...,-1 e armazenando em D(1),...
    Func = @(t) exp (j*2*pi*t*(N+1-i)/T).*funct_tri(t/2);
    D(i) = quad(Func,a,b,tol);
end

figure(1);
intervalo = -N : 1 : N; % Foi necessário definir o intervalo para que os vetores tivessem o mesmo tamanho
subplot(2,1,1); s1=stem(intervalo,abs(D));
set(s1,'Linewidth',2); 
ylabel('|{\it D}_{\it n}|');
title('Amplitude de {\it D}_{\it n}');
subplot (2,1,2); s2=stem(intervalo,angle(D));
set(s2,'Linewidth',2); ylabel('<{\it D}_{\it n}');
title('Fase de {\it D}_{\it n}');