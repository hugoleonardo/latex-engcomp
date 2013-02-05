
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
duracao = .8; %duracao em segundos
qt_amostras=duracao*1000;
r=0.05; %raio em metros
v=5; %velocidade em m/s
t=2*pi*r/v;

phi = pi/16; %angulo de abertura
t_phi = phi*r/v; %tempo da luz na abertura
n_amostras_t_phi = round(t_phi*1000);
n_amostras_low = round(t*1000 - n_amostras_t_phi - 18);

n_amostras_transicao = 9;
n_amostras_high = round(t_phi*1000)-n_amostras_transicao*2;

if(round(t_phi*1000) < 19)
    n_amostras_transicao = round(t_phi/2*1000);
    n_amostras_high = 0;
end

%######## LUMINANCIA MAXIMA E MINIMA REAL E IDEAL ########
illum_max_ideal = 100; %luminancia maxima real
illum_min_ideal = 20; %luminancia minima real
illum_relative_response = 0.7; %percepcao do valor de luminancia pelo sensor

illum_max = illum_max_ideal*illum_relative_response; %luminancia maxima dada pelo sensor
illum_min = illum_min_ideal*illum_relative_response; %luminancia minima dada pelo sensor

alfa = 180/160; %coeficiente angular da reta do sinal gerado pelo sensor segundo o datasheet

%######## CALCULO DA CORRENTE DE LUMINANCIA MAXIMA E MINIMA REAL E IDEAL ########
i_illum_max = alfa*illum_max*10^(-6); %corrente na luminancia maxima
i_illum_min = alfa*illum_min*10^(-6); %corrente na luminancia maxima

i_illum_max_ideal = alfa*illum_max_ideal*10^(-6); %corrente na luminancia maxima ideal
i_illum_min_ideal = alfa*illum_min_ideal*10^(-6); %corrente na luminancia maxima ideal

%######## CALCULO DA TENSAO DE LUMINANCIA MAXIMA E MINIMA REAL E IDEAL ########
%Photocurrent = Vout/Rss
%Vout = Photocurrent*Rss
v1_illum_max = i_illum_max*rss; %tensao na luminancia maxima
v1_illum_min = i_illum_min*rss; %tensao na luminancia minima

v1_illum_max_ideal = i_illum_max_ideal*rss; %tensao na luminancia maxima ideal
v1_illum_min_ideal = i_illum_min_ideal*rss; %tensao na luminancia minima ideal

%A = (v1_illum_max-v1_illum_min)/2; % Amplitude do sinal

%######## CALCULO DO GANHO E OFFSET ########
%calculo do ganho
dif_v1_max_e_min = v1_illum_max - v1_illum_min; %diferenca entre V1 maxima e minima
dif_v_ad_max_e_min = v_max_ad - v_min_ad; %diferenca entre V0 maxima e minima no AD
ganho = dif_v_ad_max_e_min/dif_v1_max_e_min;
%calculo do offset
v1_illum_min_amp = v1_illum_min * ganho; %tensao luminancia minima amplificada
v1_illum_max_amp = v1_illum_max * ganho; %tensao luminancia maxima amplificada
offset = v1_illum_min_amp - v_min_ad;

%######## CALCULO DAS RESISTENCIAS RH E RL ########
%calculo do RH
rh = (vref*rf)/offset;
%calculo do RL
rl = rf/((ganho - 1) - rf/rh);

%######## GERANDO SINAL REAL E IDEAL ########
i=1;
while i<qt_amostras
    tmp1 = v1_illum_min;
    tmp2 = v1_illum_max;
    v0_sinal(i) = tmp1;
    v0_sinal_ideal(i) = v1_illum_min_ideal;
    for j=1:n_amostras_transicao,
        %if (j>int64(t_phi/2)) break; end
        tmp1 = tmp1 + 0.070;
        v0_sinal(i+j) = tmp1;
        v0_sinal_ideal(i+j) = v1_illum_max_ideal;
        if ((i+j)==qt_amostras) break; end
    end
    i=(i+j);
    if (i==qt_amostras) break; end
    %v0_sinal(i+1) = tmp1+0.037;
    %v0_sinal_ideal(i+1) = v1_illum_max_ideal;
    %i=i+1;
    %if (i==qt_amostras) break; end
    l=1;
    while l<n_amostras_high+1,
        %if(t_phi<=18) break; end
        v0_sinal(i+l) = v1_illum_max;
        v0_sinal_ideal(i+l) = v1_illum_max_ideal;
        l=l+1;
        if ((i+l)==qt_amostras) break; end
    end
    i=i+l-1;
    if (i==qt_amostras) break; end
    %tmp2 = tmp2 - 0.037;
    %v0_sinal(i+1) = tmp2;
    %v0_sinal_ideal(i+1) = v1_illum_min_ideal;
    for m=1:n_amostras_transicao,
        %if (m>t_phi/2) break; end
        tmp1 = tmp1 - 0.070;
        v0_sinal(i+m) = tmp1;
        v0_sinal_ideal(i+m) = v1_illum_min_ideal;
        if ((i+m)==qt_amostras) break; end
    end
    i=i+m;
    if (i==qt_amostras) break; end
    for i=i+1:i+n_amostras_low,
        v0_sinal(i) = v1_illum_min;
        v0_sinal_ideal(i) = v1_illum_min_ideal;
        if (i==qt_amostras) break; end
    end
end

intervalo_temp = 0 : 1 : qt_amostras-1;
plot(intervalo_temp, v0_sinal),hold,plot(intervalo_temp, v0_sinal_ideal,'r');
%title('Responsividade real(azul e 70% menor) e ideal(vermelho) do sensor'); xlabel('Tempo(ms)'); ylabel('Tensão(V)');
%plot(intervalo_temp, v0_sinal);
%hold;
%subplot(1,2,2),plot(intervalo_temp, sinal);


