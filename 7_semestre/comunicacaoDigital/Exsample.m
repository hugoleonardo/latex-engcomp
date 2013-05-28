% (Exsample.m)
% Exemplo de amostragem, quantiza��o e reten��o de ordem zero
echo off; clear; clf;

td = 0.002; % taxa de amostragem de 500Hz
t = 0:td:1; % intervalo temporal de 1 segundo
xsig = sin(2*pi*t) - sin(6*pi*t); %senoides de 1Hz+3Hz
Lsig = length (xsig);

ts = 0.2; % nova taxa de amostragem  = 50Hz
Nfactor = ts/td;
% envia o sinal por meio de um quantizador  uniforme de 16 n�veis
[s_out,sq_out,sqh_out,Delta,SQNR]=sampandquant(xsig,16,td,ts);
% Recebe 3 sinais
%   1. sinal amostrado: s_out
%   2. sinal amostrado e quantizado: sq_out
%   3. sinal amostrado, quantizado e com reten��o de ordem zero: sqh_out
%
%   Calcula transformada de Fourier
Lftft = 2^ceil(log2(Lsig)+1);
Fmax = 1/(2*td);
Faxis = linspace(-Fmax,Fmax,Lfft);
Xsig = fftshift(fft(xsig,Lfft));
S_out = fftshift(fft(s_out,Lfft));
%   Exemplos de amostragem e reconstru��o usando
%       a) Trem de impulsos ideais por LPF
%       b) reconstru��o com pulso retangular por meio de LPF
%       tra�a gr�fico do sinal original e do sinal amostrado nos dom�niosdo
%       tempo e da frequ�ncia
figure(1);
subplot(3,1,1); sfig1a = plot(t,xsig,'k');
hold on; sfig1b = plot(t,s_out(1:Lsig),'b'); hold off;
set(sfig1a,'Linewidth',2); set(sfig1b,'Linewidth',2.);
xlabel('tempo, segundos');
title('sinal {\it g}({\it t}) e suas amostras uniformes');
subplot(3,1,2); sfig1c = plot(Faxis,abs(Xsig));
xlabel('Frequ�ncia (Hz)');
axis([-150 150 0 300])
set(sfig1c,'Linewidth',1); title('Espectro de {\it g}({\it t})');
subplot(3,1,3); sfig1d = plot(Faxis,abs(S_out));
xlabel('Frequ�ncia (Hz)');
axis([-150 150 0 300/Nfactor])
set(sfig1d,'Linewidth',1); title('Espectro de {\it g}_T({\it t})');
% Calcula o sinal reconstru�do a partir da amostragem ideal e 
% LPF (filtro passa-baixas) ideal
% M�xima largura do LPF � igual a a BW=floor((Lfft/Nfactor)/2);
BW = 10; % Largura de banda n�o � maior que 10Hz
H_lpf = zeros(1,Lfft); H_lpf(Lfft/2-BW:Lfft/2+BW-1) = 1; % Ideal LPF
S_recv = Nfactor*S_out.*H_lpf; % Filtragem ideal
s_recv = real (ifft(fftshift(S_recv))); % Dom�nio da frequ�ncia reconstru�do
s_recv = s_recv(1:Lsig); % Dom�nio do tempo reconstru�do
% tra�a o gr�fico do sinal reconstru�do idealmente nos dom�nios do tempo e
% da frequ�ncia
figure(2);
subplot(2,1,1); sfig2a = plot(Faxis,abs(S_recv));
xlabel('Frequ�ncia Hz');
axis([-150 150 0 300]);
title('Espectro de filtragem ideal (reconstru��o)');
subplot(2,1,2); sfig2b = plot(t,xsig,'k-.',t,s_recv(1:Lsig),'b');
legend('Sinal original','Sinal reconstru�do');
xlabel('Tempo, segundos');
title('Sinal original versus sinal reconstru�do idealmente');
set(sfig2b,'Linewidth',2);
% reconstru��o ideal
ZOH = ones(1,Nfactor);
s_ni = kron(downsample(s_out,Nfactor),ZOH);
S_ni = fftshift(fft(s_ni,Lfft));
S_recv2 = S_ni.*H_lpf % filtragem ideal
s_recv2 = real(ifft(fftshift(S_recv2))); % dom�nio da frequ�ncia reconstru�do
S_recv2 = s_recv2(1:Lsig); % dom�nio de tempo reconstru�do
% tra�a o gr�fico do sinal reconstru�do idealmente  nos dom�nios do tempo e
% da frequ�ncia
figure(3);
subplot(2,1,1); sfig3a = plot(t,xsig,'b',t,s_ni(1:Lsig),'b');
xlabel('Tempo, segundos');
title ('Sinal original  versus reconstru��o com pulso retangular');
subplot(2,1,2); sfig3b = plot(t,xsig,'b',t,s_recv2(1:Lsig),'b--');
legend('sinal original','Reconstru��o LPF');
xlabel('Tempo,segundos');
set(sfig3a,'Linewidth',2); set(sfig3b,'Linewidth',2);
title('Sinal original versus reconstru��o com pulso retangular ap�s LPF');









