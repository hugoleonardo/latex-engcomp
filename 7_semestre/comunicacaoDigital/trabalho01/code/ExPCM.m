%(ExPCM.m)
%Exemplo de amostragem, quantizacao e retencao de ordem zero
clear;clf;
td=0.002; %taxa de amostragem original 500 Hz
t=[0:td:1]; %intervalo temporal de 1 segundo
xsig=sin(2*pi*t)-sin(3*2*pi*t); %senoides de 1Hz+3Hz
Lsig=length(xsig);
Lfft=2^ceil(log2(Lsig)+1);
Xsig=fftshift(fft(xsig,Lfft));
Fmax=1/(2*td);
Faxis=linspace(-Fmax,Fmax,Lfft);
%ts=0.01; %nova taxa de amostragem = 100 Hz
ts=0.02; %nova taxa de amostragem = 50 Hz
%ts=0.04; %nova taxa de amostragem = 25 Hz
%ts=0.08; %nova taxa de amostragem = 12,5 Hz
Nfact=ts/td;
%envia o sinal por meio de um quantizador uniforme de 16 niveis
[s_sout,sq_out,sqh_out1,Delta,SQNR]=sampandquant(xsig,16,td,ts);
%sinal PCM obtido, que eh amostrado, quantizado e com retencao de ordem
%zero: sqh_out
%traca grafico do sinal original e do sinal PCM no dominio do tempo
figure(1);
subplot(211);sfig1=plot(t,xsig,'k',t,sqh_out1(1:Lsig),'b');
set(sfig1,'Linewidth',2);
title('Sinal {\it g} ({\it t}) e o correspondente sinal PCM de 16 niveis')
xlabel('tempo, segundos');
%envia o sinal por meio de um quantizador uniforme de 16 niveis
[s_out,sq_out,sqh_out2,Delta,SQNR]=sampandquant(xsig,4,td,ts);
%sinal PCM obtido, que eh amostrado, quantizado e com retencao de ordem
%zero: sqh_out
%traca grafico do sinal orogianl e do sinal PCM no dominio do tempo
subplot(212);sfig2=plot(t,xsig,'k',t,sqh_out2(1:Lsig),'b');
set(sfig2,'Linewidth',2);
title('Sinal {\it g} ({\it t}) e o correspondente de sinal PCM de 4 niveis')
xlabel('tempo, segundos');

Lfft=2^ceil(log2(Lsig)+1);
Fmax=1/(2*td);
Faxis=linspace(-Fmax,Fmax,Lfft);
SQH1=fftshift(fft(sqh_out1,Lfft));
SQH2=fftshift(fft(sqh_out2,Lfft));

%Agora, usa LPF para filtrar os dois sinais PCM
BW=10; %largura de banda nao eh maior que 10 Hz
H_lpf=zeros(1,Lfft);H_lpf(Lfft/2-BW:Lfft/2+BW-1)=1; %ideal LPF
S1_recv=SQH1.*H_lpf; %filtragem ideal
s_recv1=real(ifft(fftshift(S1_recv))); %dominio da frequencia reconstruido
s_recv1=s_recv1(1:Lsig); %dominio do tempo reconstruido
S2_recv=SQH2.*H_lpf; %filtragem ideal
s_recv2=real(ifft(fftshift(S2_recv))); %dominio da frequencia reconstruido
s_recv2=s_recv2(1:Lsig); %dominio do tempo reconstruido
%traca grafico dos sinais filtrados versus sinal original
figure(2);subplot(211);sfig3=plot(t,xsig,'b-',t,s_recv1,'b-.');
legend('original','reconstruido');set(sfig2,'Linewidth',2);
title('Sinal {\it g} ({\it t}) e o correspondente sinal PCM filtrado de 16 niveis')
xlabel('tempo, segundos');
subplot(212);sfig4=plot(t,xsig,'b-',t,s_recv2(1:Lsig),'b-.');
legend('original','reconstruido')
set(sfig4,'Linewidth',2);
title('sinal {\it g} ({\it t}) e o correspondente sinal PCM filtrado de 4 niveis')
xlabel('tempo, segundos');
