
clear all; close all; clc;


vref = 5;
%P=(U^2)/R
pd = 70*10^(-3);
rss = vref^2/pd;
rss = 10^4; %podemos truncar Rss para um valor maior ou igual a 357 Ohms para Vref 5V

v_max_ad = 4.5;
v_min_ad = .5;
vref_ad = 5;
n_bits_ad = 1;
rf=100000;


illum_max_real = 100; %luminancia maxima real
illum_min_real = 20; %luminancia minima real
illum_relative_response = 0.7; %percepcao do valor de luminancia pelo sensor

illum_max = illum_max_real*illum_relative_response; %luminancia maxima dada pelo sensor
illum_min = illum_min_real*illum_relative_response; %luminancia minima dada pelo sensor

alfa = 180/160; %coeficiente angular da reta do sinal gerado pelo sensor segundo o datasheet

i_illum_max = alfa*illum_max*10^(-6); %corrente na luminancia maxima
i_illum_min = alfa*illum_min*10^(-6); %corrente na luminancia maxima

%Photocurrent = Vout/Rss
%Vout = Photocurrent*Rss
v1_illum_max = i_illum_max*rss; %tensao na luminancia maxima
v1_illum_min = i_illum_min*rss; %tensao na luminancia minima

A = (v1_illum_max-v1_illum_min)/2; % Amplitude do sinal

%######## CALCULO DO GANHO E OFFSET ########
dif_v1_max_e_min = v1_illum_max - v1_illum_min; %diferenca entre V1 maxima e minima
dif_v_ad_max_e_min = v_max_ad - v_min_ad; %diferenca entre V0 maxima e minima no AD
%calculo do ganho
ganho = dif_v_ad_max_e_min/dif_v1_max_e_min;

v1_illum_min_amp = v1_illum_min * ganho; %tensao luminancia minima amplificada
v1_illum_max_amp = v1_illum_max * ganho; %tensao luminancia maxima amplificada
%calculo do offset
offset = v1_illum_min_amp - v_min_ad;

%######## CALCULO DAS RESISTENCIAS RH E RL ########
%calculo do RH
rh = (vref*rf)/offset;
%calculo do RL
rl = rf/((ganho - 1) - rf/rh);

qt_amostras=252;


i=1;
tmp1 = v1_illum_min;
while i<qt_amostras
    tmp1 = v1_illum_min;
    tmp2 = v1_illum_max;
    v0_sinal(i) = tmp1;
    for j=1:8,
        tmp1 = tmp1 + 0.074;
        v0_sinal(i+j) = tmp1;
    end
    i=(i+j);
    v0_sinal(i+1) = tmp1+0.037;
    i=i+1;
    for l=1:32,
        v0_sinal(i+l) = v1_illum_max;
    end
    i=(i+l);
    v0_sinal(i+1) = tmp2-0.037;
    for m=1:8,
        tmp2 = tmp2 - 0.074;
        v0_sinal(i+m) = tmp2
    end
    i=i+m
end

intervalo_temp = 0 : 1 : 295-1;
plot(intervalo_temp, v0_sinal);


