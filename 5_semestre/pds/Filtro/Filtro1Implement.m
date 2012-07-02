%Filtro 1: Ap = 1 DB Ar = 40 DB; Wp = 1000Hz; Wr = 1290; Ws = 3000 Hz;
%Precisamos primeiro achar as frequencias normalizadas Wp' e Wr';
%Achando as frequencias digitais para fazer a pré-distorção
wpd1 = (1000*2*pi)/3000;
wpd1;
wrd1 = (1290*2*pi)/3000;
wrd1;
%achando as frequencias distorcidas
wp = (6000)*tan(wpd1/2);
wp
wr = (6000)*tan(wrd1/2);
wr
ap = 1; ar = 40; ws = 3000;
wpn = sqrt(wp/wr);
wrn = sqrt(wr/wp);
wpn
wrn
%precisamos definir algumas constantes para achar a ordem N do filtro
k = 1/(wrn^2);
k
q0 = (1/2)*(1-(1-k^2)^(1/4))/(1+(1-k^2)^(1/4));
q0
q = q0 + 2*(q0^5) + 15*(q0^9) + 150*(q0^13);
q
e = sqrt((10^(0.1*ap)-1)/(10^(0.1*ar)-1));
e
n = (log10(16/(e^2)))/(log10(1/q));
n
n = 3;
%com a ordem do filtro confirmada temos que calcular mais algumas
%constantes para poder calcular as função de transferencia do filtro
teta = 1/(2*n)*(log((10^(0.05*ap)+1)/(10^(0.05*ap)-1)));
teta
syms  a q
h = (2*q^(1/4))*((symsum(((-1)^a)*(q^(a*(a+1)))*sinh((2*a+1)*teta),a,0,2)));
h
result1 = 0.3132; %result1 = 0.2801;
h2 = 1+(2*(symsum(((-1)^a)*(q^(a^2))*cosh(2*a*teta),a,1,3)));
h2
result2 = 0.9699;%result2 = 0.8665;
a = result1/result2;
a
W = ((1+(k*(a)^2))*(1+((a)^2/k)))^0.5;
W
syms  q a;
OmegaN1 = (2*q^(1/4))*((symsum(((-1)^a)*(q^(a*(a+1)))*sin(((2*a+1)*pi*1)/3),a,0,2)));
OmegaN1 = 0.5491;
OmegaD1 =  1+(2*(symsum(((-1)^a)*(q^(a^2))*cos((2*a*pi*1)/3),a,1,3)));
OmegaD1 = 1.0101;
Omega1 = OmegaN1/OmegaD1;
Omega1
V1 = ((1-(k*(Omega1)^2))*(1-((Omega1)^2/k)))^0.5;
V1
b21 = 3.3840;
a21 = 0.3878;
a11 = 0.2869;
Ho = 0.0370;
%Precisamos calcular o H(s')
v1 = [0 1 0 b21];
nN = Ho*v1;
v2 = [1 a11 a21]
a = result1/result2;
v3 = [1 a]
dN = conv(v2,v3);
%nN = 0 0.0370    0    0.1252
%dN = 1.0000    0.6098    0.4804    0.1252
%Agora precisamos fazer a desnormaização do H(s), substituindo s' por
%(1/a)*(s/wp);
var = wrn*wp;
var = 1/var;
nDes = [0 (var^2)*nN(2) 0 nN(4)];
dDes = [(var^3)*dN(1) (var^2)*dN(2) (var^1)*dN(3) dN(4)];
%nDes = 1.3264e-10 0 0.1252
%dDes = 2.1465e-13 2.1861e-09 2.8767e-05 0.1252
%após isso aplica-se a transformação bilinear e se tem o filtro digital.
vmais1 = [1 1];
vmenos1 = [1 -1];
vmenos2 = [1 -2 1];
vmais2 = [1 2 1];
vmais3 = [1 3 3 1];
vmenos3 = [1 -3 3 -1];
vn1 = vmenos2;
vn2 = vmais2;
var = 6000;
v1 = ((6000^2)*nDes(2))*vn1;
vn2 = nDes(4)*vn2;
vn2 = vn1+vn2;
vn3 = [1 1]
nDigital = conv(vn2,vn3);
vd1 = vmenos3;
vd2 = conv(vmenos2,vmais1);
vd3 = conv(vmenos1,vmais2);
vd4 = vmais3;
vd1 = ((6000^3)*dDes(1))*vd1;
vd2 = ((6000^2)*dDes(2))*vd2;
vd3 = ((6000^1)*dDes(3))*vd3;
vd4 = ((6000^0)*dDes(4))*vd4;
dDigital = vd1+vd2+vd3+vd4;
%numerador2 = 0.1300    0.3708    0.3708    0.1300
%denominador2 = 0.4229    0.3303    0.2635   -0.0151