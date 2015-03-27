% conversão analógico digital
clear all; close all; clc;

A = 2.5; % Amplitude do sinal 

f = 1.666; % Frequencia do sinal
f_a = 1000000*f; % Amostragem elevada para simular o sinal analógico 
seg = 2; % Duração do sinal em segundos
intervalo = 1/f_a; % Intervalo entre amostras na geração do sinal "analógico"
t = 0:intervalo:(seg-intervalo); % Escala temporal

sinal = A.*sin(2*pi*f*t+pi/2)+A; % Sinal gerado

n_bits = 4; %Número de bits do quantizador <-------------------
analog_range = 2*A; % 0V - *analog_range* V

freq_amostragem = 4; % frequencia de amostragem <-----------------

%########### Determinando o tamanho do vetor com o sinal quantizado #######
qt_amostras = freq_amostragem*seg;
%amostras[qt_amostras];

%in_amostras = (f_a*seg)/qt_amostras; %intervalo entre amostras
%######### Determinando proporção entre as amostras do sinal e a amostragem
in_amostras = f_a/freq_amostragem;

%intervalo_d = intervalo*in_amostras; %intervalos de tempo
%######### Determinando intervalo entre amostras do sinal amostrado
intervalo_d = 1/freq_amostragem;

t_d = 0:intervalo_d:(seg-intervalo_d); %eixo temporal (discreto)

vetor_quantizado(qt_amostras, n_bits) = 0; %vetor que guarda os valores quantizados
vetor_quantizado_converted(qt_amostras)=0;
vetor_amostra(qt_amostras)=0; %vetor que guarda os valores das amostras

amostra = 1;
%percorre o sinal original ("contínuo") e armazena os valores a cada
for linha=1:qt_amostras,
    tmp=0;
    for coluna=1:n_bits,
        if(sinal(amostra)>= analog_range/2^(coluna)+tmp)
            vetor_quantizado(linha, coluna) = 1; %seta bit
            tmp = tmp + (analog_range/2^(coluna) );%acumulador para checar o bit seguinte 
        else
            vetor_quantizado(linha,coluna) = 0; %zera bit
        end
        vetor_quantizado_converted(linha)=tmp;%salva o maior valor do acumulador, número decimal
    end
    vetor_amostra(linha) = sinal(amostra); %para o gráfico
    amostra = amostra + in_amostras; %representa o intervalo de captura de cada amostra no sinal
end
disp(vetor_quantizado);

T = t;
TD= t_d;
S1= sinal;
S2= vetor_amostra;
S3= vetor_quantizado_converted;
subplot(3,1,1), plot(T,S1),hold,stem(TD,S2,'g');
subplot(3,1,2), stem(TD,S2,'g'),hold,stairs(TD,S3,'r');
subplot(3,1,3), plot(T,S1),hold,stairs(TD,S3,'r');


xlabel('Tempo em segundos'); % Informação impressa no eixo X
ylabel('Amplitude do sinal'); % Informação impressa no eixo Y