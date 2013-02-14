%Trabalho Final de Projetos de Hardware e Interfaceamento
clear all; close all; clc;


vcc = 5;
%P=(U^2)/R
pd = 70*10^(-3);
rss = vcc^2/pd;
rss = 10^4; %podemos truncar Rss para um valor maior ou igual a 357 Ohms para Vref 5V

v_max_amp = 4.5; %tensao maxima no amplificador
v_min_amp = .5; %tensao minima no amplificador
rf=10^5;
duracao = .8; %duracao em segundos
qt_amostras=duracao*1000;
r=0.05; %raio em metros
v=.6; %velocidade em m/s
t=2*pi*r/v;
t_r=9; %tempo de resposta de leitura do sensor em ms

%######## CALCULO DOS RESISTORES PARA O COMPARADOR ########
r1=1000; %resistor 1 do divisor de tensao
v_ref_comp = 2.5;
%V=r2*Vref/(r1+r2) equacao do divisor de tensao
r2=r1*(vcc-v_ref_comp)/v_ref_comp; %resistor 2 do divisor de tensao

%######## CALCULO DO NUMERO DE AMOSTRAS EM CADA ESTADO PROPORCIONALMENTE ########
phi = pi/16; %angulo de abertura
t_phi = phi*r/v; %tempo da luz na abertura

n_amostras_t_phi = round(t_phi*1000);
n_amostras_transicao = t_r;
n_amostras_high = round(t_phi*1000)-n_amostras_transicao;
n_amostras_low = round(t*1000 - n_amostras_t_phi - n_amostras_transicao*2);

if(round(t_phi*1000) < t_r+1)
    n_amostras_transicao = round(t_phi*1000);
    n_amostras_high = 0;
end

%######## LUMINANCIA MAXIMA E MINIMA REAL E IDEAL ########
illum_max_ideal = 100; %luminancia maxima real
illum_min_ideal = 20; %luminancia minima real
illum_relative_response = 0.7; %percepcao do valor de luminancia pelo sensor
var_lux = (((illum_max_ideal-illum_min_ideal)/t_r));

illum_max = illum_max_ideal*illum_relative_response; %luminancia maxima dada pelo sensor
illum_min = illum_min_ideal*illum_relative_response; %luminancia minima dada pelo sensor

alfa = 180/160; %coeficiente angular da reta do sinal gerado pelo sensor segundo o datasheet

%######## CALCULO DA CORRENTE DE LUMINANCIA MAXIMA E MINIMA REAL E IDEAL ########
i_illum_max = alfa*illum_max*10^(-6); %corrente na luminancia maxima
i_illum_min = alfa*illum_min*10^(-6); %corrente na luminancia minima

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
dif_v_ad_max_e_min = v_max_amp - v_min_amp; %diferenca entre V0 maxima e minima no AD
ganho = dif_v_ad_max_e_min/dif_v1_max_e_min;
%calculo do offset
v1_illum_min_amp = v1_illum_min * ganho; %tensao luminancia minima amplificada
v1_illum_max_amp = v1_illum_max * ganho; %tensao luminancia maxima amplificada
offset = v1_illum_min_amp - v_min_amp;

%######## CALCULO DAS RESISTENCIAS RH E RL ########
%calculo do RH
rh = (vcc*rf)/offset;
%calculo do RL
rl = rf/((ganho - 1) - rf/rh);

%######## GERANDO SINAL REAL E IDEAL ########
v_sinal_comp(qt_amostras)=0;
i=1;
while i<qt_amostras
    %tmp1 = v1_illum_min;
    tmp = 0;
    %v0_sinal(i) = tmp1;
    v_sinal(i) = ((illum_min_ideal*illum_relative_response)*alfa*10^(-6))*rss;
    v_sinal_amp(i) = (((illum_min_ideal*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
    %v0_sinal_ideal(i) = v1_illum_min_ideal;
    v_sinal_ideal(i) = (illum_min_ideal*alfa*10^(-6))*rss;
    v_sinal_ideal_amp(i) = ((illum_min_ideal*alfa*10^(-6))*rss*ganho)-offset;
    lux_sinal(i)= illum_min_ideal*illum_relative_response;
    lux_sinal_ideal(i)=illum_min_ideal;
    %calculo do comparador
    if( v_sinal_amp(i) > v_ref_comp)
        v_sinal_comp(i) = vcc;
    end
    %borda de crescimento
    for j=1:n_amostras_transicao,
        %tmp1 = tmp1 + 0.070;
        tmp = tmp+var_lux;
        %v0_sinal(i+j) = tmp1;
        v_sinal(i+j) = (((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss;
        v_sinal_amp(i+j) = ((((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        %v0_sinal_ideal(i+j) = v1_illum_max_ideal;
        v_sinal_ideal(i+j) = (illum_max_ideal*alfa*10^(-6))*rss;
        v_sinal_ideal_amp(i+j) = ((illum_max_ideal*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal(i+j)= (illum_min_ideal+tmp)*illum_relative_response;
        lux_sinal_ideal(i+j)=illum_max_ideal;
        %calculo do comparador
        if( v_sinal_amp(i+j) > v_ref_comp)
            v_sinal_comp(i+j) = vcc;
        end
        if ((i+j)==qt_amostras) break; end
    end
    i=(i+j);
    if (i==qt_amostras) break; end
    %sinal alto
    l=1;
    while l<n_amostras_high+1,
        %v0_sinal(i+l) = v1_illum_max;
        v_sinal(i+l) = ((illum_max_ideal*illum_relative_response)*alfa*10^(-6))*rss;
        v_sinal_amp(i+l) = ((((illum_max_ideal)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        %v0_sinal_ideal(i+l) = v1_illum_max_ideal;
        v_sinal_ideal(i+l) = (illum_max_ideal*alfa*10^(-6))*rss;
        v_sinal_ideal_amp(i+l) = ((illum_max_ideal*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal(i+l)= illum_max_ideal*illum_relative_response;
        lux_sinal_ideal(i+l)=illum_max_ideal;
        %calculo do comparador
        if( v_sinal_amp(i+l) > v_ref_comp)
            v_sinal_comp(i+l) = vcc;
        end
        l=l+1;
        if ((i+l)==qt_amostras) break; end
    end
    i=i+l-1;
    if (i==qt_amostras) break; end
    %borda de descrescimento
    for m=1:n_amostras_transicao,
        %tmp1 = tmp1 - 0.070;
        tmp=tmp-var_lux;
        %v0_sinal(i+m) = tmp1;
        v_sinal(i+m) = (((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss;
        v_sinal_amp(i+m) = ((((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        %v0_sinal_ideal(i+m) = v1_illum_min_ideal;
        v_sinal_ideal(i+m) = (illum_min_ideal*alfa*10^(-6))*rss;
        v_sinal_ideal_amp(i+m) = ((illum_min_ideal*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal(i+m)= (illum_min_ideal+tmp)*illum_relative_response;
        lux_sinal_ideal(i+m)=illum_min_ideal;
        %calculo do comparador
        if( v_sinal_amp(i+m) > v_ref_comp)
            v_sinal_comp(i+m) = vcc;
        end
        if ((i+m)==qt_amostras) break; end
    end
    i=i+m;
    if (i==qt_amostras) break; end
    %sinal baixo
    for i=i+1:i+n_amostras_low,
        %v0_sinal(i) = v1_illum_min;
        v_sinal(i) = (((illum_min_ideal)*illum_relative_response)*alfa*10^(-6))*rss;
        %v0_sinal_ideal(i) = v1_illum_min_ideal;
        v_sinal_amp(i) = ((((illum_min_ideal)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        v_sinal_ideal(i) = (illum_min_ideal*alfa*10^(-6))*rss;
        v_sinal_ideal_amp(i) = ((illum_min_ideal*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal(i)= illum_min_ideal*illum_relative_response;
        lux_sinal_ideal(i)=illum_min_ideal;
        %calculo do comparador
        if( v_sinal_amp(i) > v_ref_comp)
            v_sinal_comp(i) = vcc;
        end
        if (i==qt_amostras) break; end
    end
end

intervalo_temp = 0 : 1 : qt_amostras-1;
subplot(4,2,1),plot(intervalo_temp, v_sinal),hold,plot(intervalo_temp, v_sinal_ideal,'r');
title('Sinal gerado pelo sensor real(azul) e ideal(vermelho)'); xlabel('Tempo(ms)'); ylabel('Tensão(V)');
subplot(4,2,3),plot(intervalo_temp, lux_sinal),hold,plot(intervalo_temp, lux_sinal_ideal,'r');
title('Luminância atingindo o sensor real(azul) e ideal(vermelho)'); xlabel('Tempo(ms)'); ylabel('Luminância(Lux)');
subplot(4,2,5),plot(intervalo_temp, v_sinal_amp),hold on,plot(intervalo_temp, v_sinal_comp,'g');
title('Amplificação do sinal randomico gerado pelo sensor(azul) e do comparador(vermelho)'); xlabel('Tempo(ms)'); ylabel('Tensão(V)');

%######## GERANDO SINAL RANDOMICO REAL E IDEAL ########
v_sinal_r_comp(qt_amostras)=0;
i=1;
v_counter=1;
while i<qt_amostras
    v2_r(v_counter)=rand([1 9000],1,1)*10;
    v_r(v_counter)=rand([1 9000],1,1);
    %tr=2*pi*r/v_r(v_counter);
    tr=2*pi*r/v_r(v_counter);
    %t_phi = phi*r/v_r(v_counter); %tempo da luz na abertura
    t_phi = phi*r/v_r(v_counter); %tempo da luz na abertura
    
    n_amostras_t_phi = round(t_phi*1000);
    n_amostras_transicao = t_r;
    n_amostras_high = round(t_phi*1000)-n_amostras_transicao;
    n_amostras_low = round(tr*1000 - n_amostras_t_phi - n_amostras_transicao*2);
    
    if(round(t_phi*1000) < t_r+1)
        n_amostras_transicao = round(t_phi*1000);
        n_amostras_high = 0;
    end
    
    tmp = 0;
    v_sinal_r(i) = ((illum_min_ideal*illum_relative_response)*alfa*10^(-6))*rss;
    v_sinal_r_amp(i) = (((illum_min_ideal*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
    v_sinal_r_ideal(i) = (illum_min_ideal*alfa*10^(-6))*rss;
    v_sinal_r_ideal_amp(i) = ((illum_min_ideal*alfa*10^(-6))*rss*ganho)-offset;
    lux_sinal_r(i)= illum_min_ideal*illum_relative_response;
    lux_sinal_r_ideal(i)=illum_min_ideal;
    %calculo do comparador
    if( v_sinal_r_amp(i) > v_ref_comp)
        v_sinal_r_comp(i) = vcc;
    end
    %borda de crescimento
    for j=1:n_amostras_transicao,
        tmp = tmp+var_lux;
        v_sinal_r(i+j) = (((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss;
        v_sinal_r_amp(i+j) = ((((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        v_sinal_r_ideal(i+j) = (illum_max_ideal*alfa*10^(-6))*rss;
        v_sinal_r_ideal_amp(i+j) = ((illum_max_ideal*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal_r(i+j)= (illum_min_ideal+tmp)*illum_relative_response;
        lux_sinal_r_ideal(i+j)=illum_max_ideal;
        %calculo do comparador
        if( v_sinal_r_amp(i+j) > v_ref_comp)
            v_sinal_r_comp(i+j) = vcc;
        end
        if ((i+j)==qt_amostras) break; end
    end
    i=(i+j);
    if (i==qt_amostras) break; end
    %sinal alto
    l=1;
    while l<n_amostras_high+1,
        v_sinal_r(i+l) = ((illum_max_ideal*illum_relative_response)*alfa*10^(-6))*rss;
        v_sinal_r_amp(i+l) = (((illum_max_ideal*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        v_sinal_r_ideal(i+l) = (illum_max_ideal*alfa*10^(-6))*rss;
        v_sinal_r_ideal_amp(i+l) = ((illum_max_ideal*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal_r(i+l)= illum_max_ideal*illum_relative_response;
        lux_sinal_r_ideal(i+l)=illum_max_ideal;
        %calculo do comparador
        if( v_sinal_r_amp(i+l) > v_ref_comp)
            v_sinal_r_comp(i+l) = vcc;
        end
        l=l+1;
        if ((i+l)==qt_amostras) break; end
    end
    i=i+l-1;
    if (i==qt_amostras) break; end
    %borda de descrescimento
    for m=1:n_amostras_transicao,
        tmp=tmp-var_lux;
        v_sinal_r(i+m) = (((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss;
        v_sinal_r_amp(i+m) = ((((illum_min_ideal+tmp)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        v_sinal_r_ideal(i+m) = (illum_min_ideal*alfa*10^(-6))*rss;
        v_sinal_r_ideal_amp(i+m) = ((((illum_min_ideal)*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal_r(i+m)= (illum_min_ideal+tmp)*illum_relative_response;
        lux_sinal_r_ideal(i+m)=illum_min_ideal;
        %calculo do comparador
        if( v_sinal_r_amp(i+m) > v_ref_comp)
            v_sinal_r_comp(i+m) = vcc;
        end
        if ((i+m)==qt_amostras) break; end
    end
    i=i+m;
    if (i==qt_amostras) break; end
    %sinal baixo
    for i=i+1:i+n_amostras_low,
        v_sinal_r(i) = ((illum_min_ideal*illum_relative_response)*alfa*10^(-6))*rss;
        v_sinal_r_amp(i) = (((illum_min_ideal*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        v_sinal_r_ideal(i) = (illum_min_ideal*alfa*10^(-6))*rss;
        v_sinal_r_ideal_amp(i) = (((illum_min_ideal*illum_relative_response)*alfa*10^(-6))*rss*ganho)-offset;
        lux_sinal_r(i)= illum_min_ideal*illum_relative_response;
        lux_sinal_r_ideal(i)=illum_min_ideal;
        %calculo do comparador
        if( v_sinal_r_amp(i) > v_ref_comp)
            v_sinal_r_comp(i) = vcc;
        end
        if (i==qt_amostras) break; end
    end
    v_counter=v_counter+1;
end

subplot(4,2,2),plot(intervalo_temp, v_sinal_r),hold on,plot(intervalo_temp, v_sinal_r_ideal,'r');
title('Sinal randomico gerado pelo sensor real(azul) e ideal(vermelho) do sensor'); xlabel('Tempo(ms)'); ylabel('Tensão(V)');
subplot(4,2,4),plot(intervalo_temp, lux_sinal_r),hold on,plot(intervalo_temp, lux_sinal_r_ideal,'r');
title('Luminância randomico atingindo o sensor real(azul) e ideal(vermelho) do sensor'); xlabel('Tempo(ms)'); ylabel('Luminância(Lux)');
subplot(4,2,6),plot(intervalo_temp, v_sinal_r_amp),hold on; plot(intervalo_temp, v_sinal_r_comp,'r');
title('Amplificação do sinal randomico gerado pelo sensor(azul) e do comparador(vermelho)'); xlabel('Tempo(ms)'); ylabel('Tensão(V)');

i=1;
periodo=0;
flag_high=0;
flag_low=0;
tmp_v=1;
iteste=0;
while i<qt_amostras
    iteste=v_sinal_r_comp(i);
    if( v_sinal_r_comp(i) == vcc && flag_high==0)
        flag_high=1;% primeira amostra q o sinal sobe
        i_periodo=i;
    end
    if (v_sinal_r_comp(i) == 0 && flag_high==1 && flag_low==0)
        flag_low=1;% checa se houve a descida do sinal
    end
    if (v_sinal_r_comp(i) == vcc && flag_high==1 && flag_low==1)
        f_periodo=i;% checa subida e descida de sinal e a nova subida
        v_calc(tmp_v) = 2*pi*r/(f_periodo-i_periodo)*1000;
        flag_high=0;
        flag_low=0;
        tmp_v=tmp_v+1;
    end
    i=i+1;
end
unidade1 = 1 : 1 : v_counter-1;
subplot(4,2,7),stem(unidade1,v_r);
title('Velocidade real'); xlabel('Unidade'); ylabel('Velocidade(m/s)');
unidade2 = 1 : 1 : tmp_v-1;
subplot(4,2,8),stem(unidade2,v_calc);
title('Velocidade randomica'); xlabel('Unidade'); ylabel('Velocidade(m/s)');
