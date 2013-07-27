function y = AddNoise(x, SNRperBit, BitsPerSymbol)
% function y = AddNoise(x, SNRperBit, BitsPerSymbol)
%
% This function adds noise to the vector x using the SNRperBit specified.  
% Note that l is the number of bits per symbol.
% The input vector is assumed to have unit power.
% Note also that SNRperBit is linear NOT dB.

sigma = sqrt(1/BitsPerSymbol/SNRperBit/2);

a = size(x,1);
b = size(x,2);

y = x + sigma*randn(a,b) + j*sigma*randn(a,b);