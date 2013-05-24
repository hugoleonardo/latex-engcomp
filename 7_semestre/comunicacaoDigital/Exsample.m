% (Exsample.m)
% Exemplo de amostragem, quantização e retenção de ordem zero
echo off; clear; clf;

td = 0.002; % taxa de amostragem de 500Hz
t = [0:td:1]; % intervalo temporal de 1 segundo
xsig = sin(2*pi*t) - sin(6*pi*t); %senoides de 1Hz+3Hz
Lsig = length (xsig);

ts = 0.2; % nova taxa de amostragem  = 50Hz
Nfactor = ts/td;
% envia o sinal por meio de um quantizador  uniforme de 16 níveis
[s_out,sq_out,sqh_out,Delta,SQNR] = sampandquant(xsig,16,,td,ts);
% Recebe 3 sinais
%   1. sinal amostrado: s_out
%   2. sinal amostrado e quantizado: sq_out
%   3. sinal amostrado, quantizado e com retenção de ordem zero: sqh_out
%
%   Calcula transformada de Fourier
Lftft = 2^ceil(log2(Lsig)+1);
Fmax = 1/(2*td);