function y = compress( x, mu )
% function y = compress( x, mu )
% 
% This function compresses a signal x based on mu-law companding
% using the input parameter mu.
% This performs  the opposite fucntion of expand(x,mu)
% The input signal is assumed to be between -1 and +1

y = sign(x).*log(1+mu*abs(x))/log(1+mu);

