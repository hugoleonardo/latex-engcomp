% convers�o anal�gico digital
clear all; close all; clc;

A = 20; % Amplitude do sinal 


f = 3; % Frequencia do sinal
f_a = 100000*f; % Amostragem elevada para simular o sinal anal�gico 
seg = 2; % Dura��o do sinal em segundos
intervalo = 1/f_a; % Intervalo entre amostras na gera��o do sinal "anal�gico"
t = 0:intervalo:(seg-intervalo); % Escala temporal

sinal = A.*sin(2*pi*f*t); % Sinal gerado

freq_amostragem = 10; %em Hz

qt_amostras = freq_amostragem*seg;

%qt_amostras = 200000;

i=1;
%amostras[qt_amostras];
%in_amostras = (f_a*seg)/qt_amostras; %intervalo entre amostras
%in_amostras =     f_a*seg
%             freq_amostragem* seg

in_amostras = f_a/freq_amostragem;

%intervalo_d = intervalo*in_amostras; %intervalos de tempo 

intervalo_d = 1/freq_amostragem;

amostra = 1;
vetor_amostra(qt_amostras)=0; %vetor que guarda os valores das amostras

%percorre o sinal original ("cont�nuo") e armazena os valores a cada
%intervalo de "in_amostras".
%while i<qt_amostras+1;  %representa o intervalo de captura de cada amostra do sinal
 %   vetor_amostra(i) = sinal(amostra);
  %  amostra = amostra + in_amostras;
   % i = i+1;
%end
t_d = 0:intervalo_d:(seg-intervalo_d); %eixo temporal (discreto)

N_bits = 3;
N_niveis = 2^(N_bits);
intervalo_q = (2*A)/(N_niveis); %intervalo de quantiza��o

%n�veis de quantiza��o
nivelA = -A:intervalo_q:(0-intervalo_q);
nivelB = (0+intervalo_q):intervalo_q:A;
niveis = horzcat(nivelA,nivelB);
temp(N_niveis) = 0;
vetor_quantizado(qt_amostras) = 0; %vetor que guarda os valores quantizados
amostra=1;

%percorre os valores amostrados
while amostra<qt_amostras+1;
k=1;
    %percorre cada valor amostrado pelos n�veis usados para quatiza��o
    while k<N_niveis+1;
    %armazena a diferen�a entre cada valor amostrado e os n�veis utilizados
    %como refer�ncia
    temp(k) = sinal(amostra)-niveis(k);
    %temp(k) = vetor_amostra(j)-niveis(k);
    k=k+1;
    end
%tira o m�dulo das diferen�as    
temp = abs(temp);
%pega o �ndice do n�vel que resultou na menor diferen�a
[y,x] = min(temp);
% armazena o valor de refer�ncia no vetor quantizado
vetor_quantizado(amostra) = niveis(x);
%j = j+1;
amostra = amostra + in_amostras;
end

T = t;
TD= t_d
S1= sinal;
S2= vetor_amostra;
S3= vetor_quantizado;
subplot(3,1,1), plot(T,S1),hold,stem(TD,S2,'g');
subplot(3,1,2), stem(TD,S2,'g'),hold,stairs(TD,S3,'r');
subplot(3,1,3), plot(T,S1),hold,stairs(TD,S3,'r');


xlabel('Tempo em segundos'); % Informação impressa no eixo X
ylabel('Amplitude do sinal'); % Informação impressa no eixo Y
