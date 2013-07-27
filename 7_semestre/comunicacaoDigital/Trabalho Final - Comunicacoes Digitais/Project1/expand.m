function y = expand(x, mu );
% function y = expand(x, mu );
%
% This function expands a signal x based on mu-law companding
% using the input parameter mu.
% This performs  the opposite fucntion of compress(x,mu)
% The input signal is assumed to be between -1 and +1
y = sign(x).*exp(log(1+mu)*abs(x))-1;
y = y/mu;
