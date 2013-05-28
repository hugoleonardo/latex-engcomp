%(sampandquant.m)
function[s_out,sq_out,sqh_out,Delta,SQNR]=sampandquant(sig_in,L,td,ts)
%Uso
%[s_out,sq_out,sqh_out,Delta,SQNR]=sampandquant(sig_in,L,td,fs)
%L - numero de niveis de quantizacao uniforme
%sig_in - vetor para sinal de entrada
%td - periodo original de amostragem de sinal de sig_in
%ts - novo periodo de amostragem
%NOTA: td*fs deve ser um inteiro positivo
%Saidas de funcao:
%s_out - saida amostrada
%sq_out - saida amostrada e quantizada
%sqh_out - saida amostrada, quantizada e retida
%Delta - intervalo de quantizacao
%SQNR - real relacao sinal-ruido de quantizacao

if(rem(ts/td,1)==0)
nfac=round(ts/td);
p_zoh=ones(1,nfac);
s_out=downsample(sig_in,nfac);
[sq_out,Delta,SQNR]=uniquan(s_out,L);
s_out=upsample(s_out,nfac);
sqh_out=kron(sq_out,p_zoh);
sq_out=upsample(sq_out,nfac);
else
warning('Erro! ts/td nao eh umm inteio!');
s_out=[];sq_out=[];sqh_out=[];Delta=[];SQNR=[];
end
end
