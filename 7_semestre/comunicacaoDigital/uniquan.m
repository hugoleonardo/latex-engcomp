%(uniquan.m)
function [q_out,Delta,SQNR] = uniquan(sig_in,L)

%Uso
%[q_out,Delta,SQNR] = uniquan(sig_in,L)
%L - numero de niveis de quantizacao uniforme
%sign_in - vetor para sinal de entrada
%saidas de funcao:
%	q_out - saida quantizada
%	Delta - intervalo de quantizacao
%	SQNR - real relacao sinal-ruido positivos
sig_pmax=max(sig_in); %determina pico positivo
sig_nmax=min(sig_in); %determina pico negativo
Delta=(sig_pmax-sig_nmax)/L; %intervalo de quantizacao
q_level=sig_nmax+Delta/2:Delta:sig_pmax-Delta/2; %define Q niveis
L_sig=length(sig_in); %determina comprimento do sinal
sigp=(sig_in-sig_nmax)/Delta+1/2; %converte a faixa de 1/2 a L+1/2
qindex=round(sigp); %arredonda a 1,2,3 ... L niveis
qindex=min(qindex,L); %elimina L+1 como possibilidade rara
q_out=q_level(qindex); %usa vetor index para gerar saida
SQNR=20*log10(norm(sig_in)/norm(sig_in-q_out)); %valor da SQNR
end
