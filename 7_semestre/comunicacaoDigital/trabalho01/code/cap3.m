Ts=1/64; T0=4; N0=T0/Ts;
t=0:Ts:Ts*(N0-1); t=t';
g=Ts*exp(-2*t);
g(1)=Ts*0.5;
G=fft(g);
[Gp,Gm]=cart2pol(real(G),imag(G));
k=0:N0-1; k=k';
w=2*pi*k/T0;
subplot(211),stem(w(1:32), Gm(1:32));
subplot(212),stem(w(1:32),Gp(1:32));

%B=4; f0=1/4;
%Ts=1/(2*B); 
%T0=1/f0;
%N0=T0/Ts;
%k=0:N0; k=k';
%for m=1:length(k)
%    if k(m)>=0 && k(m)<=3, gk(m)=1; end
%    if k(m)==4 || k(m)==28 gk(m)=0.5; end %modifiquei o if de && para ||
%    if k(m)>=5 && k(m)<=27, gk(m)=0; end
%    if k(m)>=29 && k(m)<=32, gk(m)=1; end %modifiquei colocando 32 em vez de 31 para que os vetores k e gk fossem do mesmo tamanho para a plotagem.
%end
%gk=gk';
%Gr=fft(gk);
%subplot(221),stem(k,gk);
%subplot(212),stem(k,Gr);