% Gerar o sinal a partir da curva do termistor
% amplificar o sinal e normalizar
% 1.Calcular o número de níveis que será utilizado (antes da amplificação
%   do sinal)
% 2.Encontrar o número de níveis por ºC
% 3.Encontrar o ganho do sinal necessário para amplificação na faixa
%   entre 0.5 e 4.5 volts (0.5 volts de cada lado como margem de
%   segurança)
% 4.Encontrar o offset do sinal
% 5. Definir o valor de Rf
% 6. Encontrar o valor de Rh (pela equação do offset)
% 7. Encontrar o valor de RL (pela equação do ganho)
%

% ######## CALCULO DO SINAL DO TERMISTOR ########
clear all; close all; clc;

vref = 2.5; % tensão de referencia
v_max_ad = 4.5;
v_min_ad = .5;
temp_min = 10;
temp_max = 40;
rf = 100000;
r1 = 10000;
vref_ad = 5;
variacao_temp = 0.6;
n_bits_ad = 5;

%dc = 0.002; %em W/ºC
%precisao = 0.5; %em ºC

%potencia = dc*precisao*(1/2);% potencia maxima dissipada pelo termistor, 1/2 gera uma faixa de segurança

%resistencia nominal máxima do termistor

%et = sqrt(potencia*rt); %tensão em r

%ct = et/rt; %corrente no termistor

%e1 = vref - et; %tensao no r1

%r1 = e1/ct; %valor mínimo de r1

%aumentar do valor minimo de r1

%v1 = vref*rt/(rt+r1)

rt_temp_max = 1145 + 26101*1.5.^(-temp_max/10); %resistencia do termistor na temperatura maxima
rt_temp_min = 1145 + 26101*1.5.^(-temp_min/10); %resistencia do termistor na temperatura minima

v1_temp_max = (vref*rt_temp_max)/(rt_temp_max+r1); %tensao de V1 na temperatura maxima(entrada do ampop)
v1_temp_min = (vref*rt_temp_min)/(rt_temp_min+r1); %tensao de V1 na temperatura minima (entrada do ampop)
erro = 0.05;%valor pequeno
A = (v1_temp_min*(1+erro)-v1_temp_max*(1-erro))/2; % Amplitude do sinal 
%erro = 0.05;%valor pequeno
%A_err = A*(1+erro);
f = 1/48; % Frequencia do sinal
f_a = 60*24*f; % Amostragem elevada para simular o sinal analÃ³gico 
seg = 24; % DuraÃ§Ã£o do sinal em segundos
intervalo = 1/f_a; % Intervalo entre amostras na geraÃ§Ã£o do sinal "analÃ³gico"
%intervalo = 60;
t = 0:intervalo:(seg-intervalo); % Escala temporal

sinal = v1_temp_min*(1+erro)-A + A.*cos(2*pi*f*t); % Sinal gerado

%freq_amostragem

%f = 3; % Frequencia do sinal
%f_a = 100000*f; % Amostragem elevada para simular o sinal analÃ³gico 
%seg = 2; % DuraÃ§Ã£o do sinal em segundos
%intervalo = 1/f_a; % Intervalo entre amostras na geraÃ§Ã£o do sinal "analÃ³gico"
%t = 0:intervalo:(seg-intervalo); % Escala temporal

qt_amostras = 720;


%######## RESOLUCAO DO ADC A APARTIR DO V1(SINAL DO TERMISTOR) ########
%fix arredonda para numero inteiro em direcao ao zero
nivel_temp_min = fix( (v1_temp_min/vref_ad) * 2^n_bits_ad ); %nivel da temperatura minima no AD
nivel_temp_max = fix( (v1_temp_max/vref_ad) * 2^n_bits_ad ); %nivel da temperatura maxima no AD

n_niveis_utilizados = nivel_temp_min - nivel_temp_max; %numero de niveis entre temperatura maxima e minima no AD
n_graus = temp_max - temp_min + 1; %numero de graus entre temperatura maxima e minima
n_niveis_por_grau = n_niveis_utilizados/n_graus; %numero de niveis por grau


%######## CALCULO DO GANHO E OFFSET ########
dif_v1_min_e_max = v1_temp_min - v1_temp_max; %diferenca entre V1 minima e maxima
dif_v_ad_max_e_min = v_max_ad - v_min_ad; %diferenca entre V0 maxima e minima no AD
%calculo do ganho
ganho = dif_v_ad_max_e_min/dif_v1_min_e_max;

vt_temp_min_amp = v1_temp_min * ganho; %tensao temperatura minima amplificada
vt_temp_max_amp = v1_temp_max * ganho; %tensao temperatura maxima amplificada
%calculo do offset
offset = vt_temp_max_amp - v_min_ad;

%######## CALCULO DAS RESISTENCIAS RH E RL ########
%calculo do RH
rh = (vref*rf)/offset;
%calculo do RL
rl = rf/((ganho - 1) - rf/rh);

%gera os valores de rt a partir das temperaturas maxima e minima considerando
%a variacao de temperatura setada no cabecalho
intervalo_temp = temp_min : variacao_temp : temp_max;
rt = 1145 + 26101*1.5.^(-intervalo_temp/10);

%######## GERANDO V1 E V0 ########
n_amostras = (temp_max - temp_min)/variacao_temp + 1; %numero de amostras

vetor_amostras = 1 : 1 : n_amostras;

v1(n_amostras)=0;
v0(n_amostras)=0;
for i=1:n_amostras,
    v1(i) = (vref*rt(i))/(rt(i)+r1); %V1 (entrada do ampop)
    v0(i) = v1(i)*(1 + rf/rl + rf/rh) - vref*rf/rh; %V0(saida do circuito)
end

v0_sinal(qt_amostras)=0;
for i=1:qt_amostras,
    v0_sinal(i) = sinal(i)*(1 + rf/rl + rf/rh) - vref*rf/rh;
end

vetor_quantizado(n_amostras, n_bits_ad) = 0;
vetor_quantizado_c1(n_amostras, n_bits_ad) = 0;
vetor_quantizado_v1(n_amostras, n_bits_ad) = 0;
vetor_quantizado_v1_c1(n_amostras, n_bits_ad) = 0;
vetor_quantizado_converted_tensao(n_amostras)=0;
vetor_quantizado_converted_tensao_c1(n_amostras)=0;
vetor_quantizado_converted_tensao_v1(n_amostras)=0;
vetor_quantizado_converted_tensao_v1_c1(n_amostras)=0;
vetor_quantizado_converted_graus(n_amostras)=0;
vetor_quantizado_converted_graus_c1(n_amostras)=0;



for linha=1:n_amostras,
    tmp=0;
    tmp2=vref_ad;
    tmp_v1 = 0;
    tmp2_v1 = vref_ad;
    for coluna=1:n_bits_ad,
        if(v0(linha)>= vref_ad/2^(coluna)+tmp)
            vetor_quantizado(linha, coluna) = 1; %seta bit
            vetor_quantizado_c1(linha, coluna) = 0; %seta bit
            tmp = tmp + (vref_ad/2^(coluna) );%acumulador para checar o bit seguinte
            tmp2 = tmp2 - (vref_ad/2^(coluna) );
        else
            vetor_quantizado(linha,coluna) = 0; %zera bit
            vetor_quantizado_c1(linha, coluna) = 1; %seta bit
        end
        vetor_quantizado_converted_tensao(linha)=tmp;%salva o maior valor do acumulador, número decimal
        vetor_quantizado_converted_tensao_c1(linha)=tmp2;%salva o maior valor do acumulador, número decimal
        vetor_quantizado_converted_graus(linha)=tmp*(temp_max/v_max_ad);
        vetor_quantizado_converted_graus_c1(linha)=tmp2*temp_max/v_max_ad;
    end
    for coluna=1:n_bits_ad,
        if(v1(linha)>= vref_ad/2^(coluna)+tmp_v1)
            vetor_quantizado_v1(linha, coluna) = 1; %seta bit
            vetor_quantizado_v1_c1(linha, coluna) = 0; %seta bit
            tmp_v1 = tmp_v1 + (vref_ad/2^(coluna) );%acumulador para checar o bit seguinte
            tmp2_v1 = tmp2_v1 - (vref_ad/2^(coluna) );
        else
            vetor_quantizado_v1(linha,coluna) = 0; %zera bit
            vetor_quantizado_v1_c1(linha, coluna) = 1; %seta bit
        end
        vetor_quantizado_converted_tensao_v1(linha)=tmp_v1;%salva o maior valor do acumulador, número decimal
        vetor_quantizado_converted_tensao_v1_c1(linha)=tmp2_v1;%salva o maior valor do acumulador, número decimal
    end
    %vetor_quantizado_converted(linha)=tmp;%salva o maior valor do acumulador, número decimal
    %vetor_amostra(linha) = sinal(amostra); %para o gráfico
    %amostra = amostra + in_amostras; %representa o intervalo de captura de cada amostra no sinal
end

%plot(intervalo_temp,vetor_quantizado);
%figure;
%plot(intervalo_temp,vetor_quantizado_c1);
%figure;
%vetor_quantizado_converted
%plot(n_amostras,vetor_quantizado_converted);

subplot(3,2,1),plot(intervalo_temp,v1),hold,stairs(intervalo_temp,vetor_quantizado_converted_tensao_v1,'black');
title('Sinal do termistor'); xlabel('Temperatura'); ylabel('Tensão');
subplot(3,2,2),plot(intervalo_temp,v0,'r');
title('Sinal do termistor Amplificado(V0)'); xlabel('Temperatura'); ylabel('Tensão');
subplot(3,2,3),plot(intervalo_temp,vetor_quantizado_converted_tensao,'g'),hold,plot(intervalo_temp,vetor_quantizado_converted_tensao_v1,'black');
title('V0 quantizado'); xlabel('Temperatura'); ylabel('Tensão');
subplot(3,2,4),stairs(intervalo_temp,vetor_quantizado_converted_tensao_c1,'m');
title('V0 quantizado Complemento de 1'); xlabel('Temperatura'); ylabel('Tensão');
subplot(3,2,5),stairs(vetor_amostras,vetor_quantizado_converted_graus,'b');
title('Variação de Temperatura'); xlabel('Amostra'); ylabel('Temperatura');
subplot(3,2,6),stairs(vetor_amostras,vetor_quantizado_converted_graus_c1,'black');
title('Variação de Temperatura'); xlabel('Amostra'); ylabel('Temperatura');



%subplot(3,2,5),plot(t,sinal, 'c');
%subplot(2,2,2),stem(intervalo_temp,vetor_quantizado_c1);
%plot(rtabc,v1); %hold; plot(res_term_min,'b'); hold; plot(res_term_max,'r');
%figure;
%plot(rtabc,v0);
%figure;
%stairs(rt,v1,'r');
