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
    
    vref_AD = 5;
    
    dc = 0.002; % em W/ºC
    precisao = 0.5; % em ºC
    
    potencia = dc*precisao*(1/2); % potencia maxima dissipada pelo termistor, 1/2 gera uma faixa de segurança
    
    %rt = 10000; % resistencia nominal máxima do termistor
    
    %et = sqrt(potencia*rt); % tensão em r
    
    %ct = et/rt; % corrente no termistor
    
    %e1 = vref - et; % tensao no r1
    
    %r1 = e1/ct; % valor mínimo de r1
    
    r1 = 10000; % aumentar do valor minimo de r1
    
    %v1 = vref*rt/(rt+r1)

    % ######## CALCULO DA RESOLUCAO ########
    
    %rt_temp_min = 18200; % resistencia do termistor a 10ºC
    %rt_temp_max = 6406;  % resistencia do termistor a 40ºC
    
    vt_temp_min = 1.61;
    vt_temp_max = 0.976;
   
    temp_min = 10;
    temp_max = 40;
    
    n_bits = 8;
    
    nivel_temp_min = (vt_temp_min/vref_AD) * 2^n_bits;
    
    nivel_temp_max = (vt_temp_max/vref_AD) * 2^n_bits;
    
    niveis_utilizados = nivel_temp_min - nivel_temp_max;
    
    intervalo_graus = temp_max - temp_min;
    
    niveis_grau = niveis_utilizados/intervalo_graus;
    
    rf = 100000; % definir valor de rf para facilitar os calculos
    
    temp_1 = vt_temp_min - vt_temp_max;
    
    temp_2 = (vref_AD-0.5) - 0.5;
    
    ganho = (temp_2)/(temp_1);
    
        
    vt_temp_min_amp = vt_temp_min * ganho;
    vt_temp_max_amp = vt_temp_max * ganho;
    
    offset = vt_temp_max_amp - .5;
    
    rh = (vref*rf)/offset; %Rh
    
    rl = rf/((ganho - 1) - (rf/rh)); %RL 
  
   
    intervalo = 0.25; 
    
    temp = 10:intervalo:40;
    %rtabc = 1145 + 26101*1.5.^(-temp/10);
    
    rt_temp_max = 1145 + 26101*1.5.^(-temp_max/10);    
    rt_temp_min = 1145 + 26101*1.5.^(-temp_min/10);
    
    intervalo_rt = (rt_temp_min - rt_temp_max) / intervalo_graus;
    
    rtabc = rt_temp_max:intervalo_rt:rt_temp_min;
    rt=rt_temp_max;
    v1(intervalo_graus)=0;
    v0(intervalo_graus)=0;
    for i=1:intervalo_graus+1,
        v1(i) = (vref*rt)/(rt+r1); %equacao de v1 (entrada do ampop)
        rt=rt+intervalo_rt;
        %v0(i) = v1(i)*(1+ (rf/rl) + (rf/rh) - ((vref*rf)/rh)); %equacao de saida do circuito
        v0(i) = v1(i)*ganho - offset;
    end
    
    v0
   
    %Equação
    
    % y = 1145 + 26101*x^(-temp/10) x = ??????
    %temp_min = 10; %supondo que, em 10 graus, a resistencia é 18.200k
    %temp_max = 40; %supondo que, em 40 graus, a resistencia é  6.406k
    
    %res_term_min = .1145 + .26101*25.^(-18200/10);
    %res_term_max = .1145 + .26101*25.^(-6406/10);
    subplot(2,1,1),plot(rtabc,v1);
    subplot(2,1,2),plot(rtabc,v0);
    %plot(rtabc,v1); %hold; plot(res_term_min,'b'); hold; plot(res_term_max,'r');
    %figure;
    %plot(rtabc,v0);
    %figure;
    %stairs(rt,v1,'r');
    
    