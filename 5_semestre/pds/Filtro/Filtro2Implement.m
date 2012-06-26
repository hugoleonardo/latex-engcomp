%Filtro 2
%Ap=0.5, Ar=65, Wp1=40, Wp2=80, Wr1=50, Wr2=70, Ws=240
%Como esse é um filtro rejeita faixa precisamos achar o intervalo de
%rejeição normalizado wr1 e wr2.
%Precisamos achar as frequencias pré distorcidas.
%Primeiro as frequencias digitais
wpd1 = (6.36*2*pi)/38.19;
wpd1 
wpd2 = (12.73*2*pi)/38.19;
wpd2 
wrd1 = (7.95*pi*2)/38.19;
wrd1 
wrd2 = (11.14*pi*2)/38.19;
wrd2
%Acharemos agora as frequencias distorcidas
wp1 = (240/pi)*tan(wpd1/2);
wp1
wp2 = (240/pi)*tan(wpd2/2);
wp2 
wr1 = (240/pi)*tan(wrd1/2);
wr1
wr2 = (240/pi)*tan(wrd2/2);
wr2
omega0 = wr1*wr2;
omega0
B = wr2-wr1;
B
ac = sqrt((wp2-wp1)/(wr2-wr1));
ac
%acharemos agora as frequencias do filtro passa baixa normalizado
%equivalente
wp = 1/ac;
wp
wr = (1/ac)*((wp2-wp1)/(wr2-wr1));
wr
k = 1/(wr^2);
k
q0 = (1/2)*(1-(1-k^2)^(1/4))/(1+(1-k^2)^(1/4));
q0
q = q0 + 2*(q0^5) + 15*(q0^9) + 150*(q0^13);
q
e = sqrt((10^(0.1*0.5)-1)/(10^(0.1*65)-1));
e
n = (log10(16/(e^2)))/(log10(1/q));
n
n = 5;
%com a ordem do filtro confirmada temos que calcular mais algumas
%constantes para poder calcular as função de transferencia do filtro
teta = 1/(2*n)*log((10^(0.05*0.5)+1)/(10^(0.05*0.5)-1));
teta
syms  a q
h = (2*q^(1/4))*((symsum(((-1)^a)*(q^(a*(a+1)))*sinh((2*a+1)*teta),a,0,2)));
h
result1 = 0.2688;
h2 = 1+(2*(symsum(((-1)^a)*(q^(a^2))*cosh(2*a*teta),a,1,3)));
h2
result2 = 0.9607;
a = result1/result2;
a
W = ((1+(k*(a)^2))*(1+((a)^2/k)))^0.5;
W
syms  q a;
OmegaN1 = (2*q^(1/4))*((symsum(((-1)^a)*(q^(a*(a+1)))*sin(((2*a+1)*pi*1)/5),a,0,3)));
OmegaN1
OmegaN1 = 0.4127;
OmegaD1 =  1+(2*(symsum(((-1)^a)*(q^(a^2))*cos((2*a*pi*1)/5),a,1,4)));
OmegaD1 = 0.9906;
Omega1 = OmegaN1/OmegaD1;
Omega1
V1 = ((1-(k*(Omega1)^2))*(1-((Omega1)^2/k)))^0.5;
V1
OmegaN2 = (2*q^(1/4))*((symsum(((-1)^a)*(q^(a*(a+1)))*sin(((2*a+1)*pi*2)/5),a,0,3)));
OmegaN2
OmegaN2 = 0.6681
OmegaD2 =  1+(2*(symsum(((-1)^a)*(q^(a^2))*cos((2*a*pi*2)/5),a,1,4)));
OmegaD2
OmegaD2 = 1.0246
Omega2 = OmegaN2/OmegaD2;
Omega2
V2 = ((1-(k*(Omega2)^2))*(1-((Omega2)^2/k)))^0.5;
V2
b21 = 5.7614;
b22 = 2.3519;
a11 = 0.4190;
a12 = 0.1417;
a21 = 0.2485;
a22 = 0.4872;
h0 = 0.0025;
%coeficientes do filtro passa-baixa normalizado
%Numerador:  0.0025         0    0.0203         0    0.0339
%Denominador: 1.0000    0.8405    0.9520    0.4618    0.1880    0.0339
%coeficientes do filtro rejeita faixa desnomalizado
%numeradorDesnormalizado = 0.0339 0 988.3928 0 1.1527e+07 0 6.7215e+10 0 1.9597e+14 0 2.2855e+17
%denominadorDesnormalizado = 0.0339 7.7139 1.7655e+03 245641 27493400 1.6899e+09 1.6037e+11  8.3524e+12   3.5006e+14  8.9184e+15 2.2854e+17
%após a aplicação da transformação bilinear tem-se os coeficientes do
%filtro digital
%numeradorDigital = 1.0e+19 * 0.7329   -0.0031    3.6645   -0.0124    7.3290   -0.0186    7.3290   -0.0124    3.6645   -0.0031    0.7329
%DenominadorDigital = 1.0e+19 * 3.0689   -0.0093    6.8262   -0.0163    7.7621   -0.0111    4.3854   -0.0041    1.3743   -0.0004    0.0268
   

