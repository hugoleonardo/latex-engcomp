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

vref = 2.5; % tensão de referencia
v_max_ad = 4.5;
v_min_ad = 0.5;
temp_min = 10;
temp_max = 40;
rf = 100000;
r1 = 10000;
vref_ad = 5;
variacao_temp = 1;
n_bits_ad = 8;

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
v1(n_amostras)=0;
v0(n_amostras)=0;
for i=1:n_amostras,
    v1(i) = (vref*rt(i))/(rt(i)+r1); %V1 (entrada do ampop)
    v0(i) = v1(i)*(1 + rf/rl + rf/rh) - vref*rf/rh; %V0(saida do circuito)
end

vetor_quantizado(n_amostras, n_bits_ad) = 0;
vetor_quantizado_c1(n_amostras, n_bits_ad) = 0;
vetor_quantizado_converted(n_amostras)=0;

for linha=1:n_amostras,
    tmp=0;
    for coluna=1:n_bits,
        if(v0(linha)>= vref_ad/2^(coluna)+tmp)
            vetor_quantizado(linha, coluna) = 1; %seta bit
            vetor_quantizado_c1(linha, coluna) = 0; %seta bit
            tmp = tmp + (vref_ad/2^(coluna) );%acumulador para checar o bit seguinte
        else
            vetor_quantizado(linha,coluna) = 0; %zera bit
            vetor_quantizado_c1(linha, coluna) = 1; %seta bit
        end
        vetor_quantizado_converted(linha)=tmp;%salva o maior valor do acumulador, número decimal
    end
    %vetor_amostra(linha) = sinal(amostra); %para o gráfico
    %amostra = amostra + in_amostras; %representa o intervalo de captura de cada amostra no sinal
end

subplot(2,1,1),stem(intervalo_temp,v1);
subplot(2,1,2),stem(intervalo_temp,v0);
subplot(2,2,1),stem(intervalo_temp,vetor_quantizado);
subplot(2,2,2),stem(intervalo_temp,vetor_quantizado_c1);
%plot(rtabc,v1); %hold; plot(res_term_min,'b'); hold; plot(res_term_max,'r');
%figure;
%plot(rtabc,v0);
%figure;
%stairs(rt,v1,'r');

