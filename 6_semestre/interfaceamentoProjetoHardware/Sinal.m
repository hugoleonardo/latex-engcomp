% convers�o anal�gico digital
clear all; close all; clc;

A = 2; % Amplitude do sinal 
f = 3; % Frequencia do sinal
f_a = 100000*f; % Amostragem elevada para simular o sinal anal�gico 
seg = 2; % Dura��o do sinal em segundos
intervalo = 1/f_a; % Intervalo entre amostras na gera��o do sinal "anal�gico"
t = 0:intervalo:(seg-intervalo); % Escala temporal

sinal = A.*sin(2*pi*f*t); % Sinal gerado

plot(t,sinal); % Plotagem do sinal
xlabel('Tempo em segundos'); % Informa��o impressa no eixo X
ylabel('Amplitude do sinal'); % Informa��o impressa no eixo Y
