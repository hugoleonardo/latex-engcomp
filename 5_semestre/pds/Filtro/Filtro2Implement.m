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
a = result1/result2;
b21 = 5.7614;
b22 = 2.3519;
a11 = 0.4190;
a12 = 0.1417;
a21 = 0.2485;
a22 = 0.4872;
h0 = 0.0025;
%h(s')
vn1 = [1 0 b21];
vn2 = [1 0 b22];
nN = conv(vn1,vn2);
nN = h0*nN;
vd1 = [1 a11 a21];
vd2 = [1 a12 a22];
vd3 = conv(vd1,vd2);
vd4 = [1 a];
dN = conv(vd4,vd3);
%coeficientes do filtro passa-baixa normalizado
%Numerador:  0.0025         0    0.0203         0    0.0339
%Denominador: 1.0000    0.8405    0.9520    0.4618    0.1880    0.0339
var = wp*B;
vn1 = [0 0 0 0 0 0 0 0 var^4*nN(1)];
vn2 = [0 0 0 0 (var^2)*nN(3) 0 (var^2)*nN(3)*2*omega0 0 (var^2)*nN(3)*(omega0^2)];
vn3 = [nN(5) 0 nN(5)*4*omega0 0 nN(5)*6*(omega0^2) 0 nN(5)*4*(omega0^3) 0 nN(5)*(omega0^4)];
vn4 = vn1+vn2+vn3;
vn5 = [1 0 omega0];
nDes = conv(vn4,vn5);
vd1 = [0 0 0 0 0 var^5*(dN(1)) 0 0 0 0 0];
vd2 = [0 0 0 0 (var^4)*dN(2) 0 (var^4)*dN(2)*omega0 0 0 0 0];
vd3 = [0 0 0 (var^3)*dN(3) 0 (var^3)*dN(3)*2*omega0 0 (var^3)*dN(3)*(omega0^2) 0 0 0];
vd4 = [0 0 var^2*dN(4) 0  var^2*dN(4)*3*omega0 0  var^2*dN(4)*3*(omega0^2) 0  var^2*dN(4)*(omega0^3)  0  0];
vd5 = [0 var*dN(5) 0  var*dN(5)*4*omega0 0  var*dN(5)*6*(omega0^2) 0  var*dN(5)*4*(omega0^3) 0  var*dN(5)*(omega0^4) 0];
vd6 = [dN(6) 0 omega0*dN(6)*5 0 (omega0^2)*dN(6)*10 0 (omega0^3)*dN(6)*10 0 (omega0^4)*dN(6)*5 0 (omega0^5)*dN(6)];
dDes = vd1 + vd2 + vd3 + vd4 + vd5 + vd6;
%coeficientes do filtro rejeita faixa desnomalizado
%numeradorDesnormalizado = 0.0339 0 988.3928 0 1.1527e+07 0 6.7215e+10 0 1.9597e+14 0 2.2855e+17
%denominadorDesnormalizado = 0.0339 7.7139 1.7655e+03 245641 27493400 1.6899e+09 1.6037e+11  8.3524e+12   3.5006e+14  8.9184e+15 2.2854e+17
%após a aplicação da transformação bilinear tem-se os coeficientes do
vmais10 = [1 10 45 120 210 252 210 120 45 10 1];
vmenos10 = [1 -10 45 -120 210 -252 210 -120 45 -10 1];
vmais9 = [1     9    36    84   126   126    84    36     9     1];
vmenos9 = [1     -9    36    -84   126   -126    84    -36     9  -1];
vmais8 = [1 8 28 56 70 56 28 8 1];
vmais7 = [1     7    21    35    35    21     7     1];
vmenos7 = [1     -7    21    -35    35    -21     7     -1];
vmenos8 = [1 -8 28 -56 70 -56 28 -8 1];
vmais6 = [1 6 15 20 15 6 1];
vmenos6 = [1 -6 15 -20 15 -6 1];
vmais5 = [1 5 10 10 5 1];
vmenos5 =[1 -5 10 -10 5 -1];
vmais4 = [1 4 6 4 1];
vmenos4 = [1 -4 6 -4 1];
vmais3 = [1 3 3 1];
vmenos3 = [1 -3 3 -1];
vmais2 = [1 2 1];
vmenos2 = [1 -2 1];
vmais1 = [1 1];
vmenos1 = [1 -1];
var2 = 240/pi;
vn1 = vmenos10;
vn1 = (var2^10)*nDes(1)*vn1;
vn2 = conv(vmenos8,vmais2);
vn2 = (var2^8)*nDes(3)*vn2;
vn3 = conv(vmenos6,vmais4);
vn3 = (var2^6)*nDes(5)*vn3;
vn4 = conv(vmenos4,vmais6);
vn4 = (var2^4)*nDes(7)*vn4;
vn5 = conv(vmenos2,vmais8);
vn5 = (var2^2)*nDes(9)*vn5;
vn6 = vmais10;
vn6 = (var2^0)*nDes(11)*vn6;
nDigital = vn1+vn2+vn3+vn4+vn5+vn6;
vd1 = vmenos10;
vd1 = (var2^10)*dDes(1)*vd1;
vd2 = conv(vmenos9,vmais1);
vd2 = (var2^9)*dDes(2)*vd2;
vd3 = conv(vmenos8,vmais2);
vd3 = (var2^8)*dDes(3)*vd3;
vd4 = conv(vmenos7,vmais3);
vd4 = (var2^7)*dDes(4)*vd4;
vd5 = conv(vmenos6,vmais4);
vd5 = (var2^6)*dDes(5)*vd5;
vd6 = conv(vmenos5,vmais5);
vd6 = (var2^5)*dDes(6)*vd6;
vd7 = conv(vmenos4,vmais6);
vd7 = (var2^4)*dDes(7)*vd7;
vd8 = conv(vmenos3,vmais7);
vd8 = (var2^3)*dDes(8)*vd8;
vd9 = conv(vmenos2,vmais8);
vd9 = (var2^2)*dDes(9)*vd9;
vd10 = conv(vmenos1,vmais9);
vd10 = (var2^1)*dDes(10)*vd10;
vd11 = vmais10;
vd11 = (var2^0)*dDes(11)*vd11;
dDigital = vd1+vd2+vd3+vd4+vd5+vd6+vd7+vd8+vd9+vd10+vd11;
%filtro digital
%numeradorDigital = 1.0e+19 * 0.7329   -0.0031    3.6645   -0.0124    7.3290   -0.0186    7.3290   -0.0124    3.6645   -0.0031    0.7329
%DenominadorDigital = 1.0e+19 * 3.0689   -0.0093    6.8262   -0.0163    7.7621   -0.0111    4.3854   -0.0041    1.3743   -0.0004    0.0268
   

