% conversão analógico digital
clear all; close all; clc;

A = 2; % Amplitude do sinal 
f = 3; % Frequencia do sinal
f_a = 100000*f; % Amostragem elevada para simular o sinal analógico 
seg = 2; % Duração do sinal em segundos
intervalo = 1/f_a; % Intervalo entre amostras na geração do sinal "analógico"
t = 0:intervalo:(seg-intervalo); % Escala temporal

sinal = A.*sin(2*pi*f*t); % Sinal gerado

plot(t,sinal); % Plotagem do sinal
xlabel('Tempo em segundos'); % Informação impressa no eixo X
ylabel('Amplitude do sinal'); % Informação impressa no eixo Y
