function y = analog2digital(x, f_s, bits, companding, mu, f_s_original)

%  function y = analog2digital(x, f_s, bits, companding, mu, f_s_original)
%
%  This function converts an 'analog' (i.e., highly oversampled continuous
%  amplitude signal) to a digital signal (i.e., a vector of ones and
%  zeros).
%
% x is the input vector
% 
% f_s is the desired sampling rate
%
% bits is the number of bits per sample (i.e., quantization levels =
% 2^bits)
%
% companding is a binary value which specifies whether or not companding is
% to be used.  If companding is not 0 (i.e., any value other than zero is
% interpreted as true) the value of mu must be specified (mu-law companding
% is assumed).  If companding == 0, mu need not be specified.
%
% f_s_original is the original sampling rate of the 'analog' signal. It is
% assumed to be 65536 unless specified.  Thus, f_s_original is also an
% optional input variable.

levels = 2^bits;

% Perform sampling
if nargin > 5
    samp = sample(x, f_s, f_s_original);
else
    samp = sample(x, f_s);
end


% perform quantization
if companding == 0
    quant = uniformquantize(samp, levels);
else
    tmp = compress(samp, mu);
    quant = uniformquantize(tmp, levels);
end

% convert quantized values to bits
L = -1+2/levels/2:2/levels:1;

if size(quant,2) > 1
   quant = quant';
end

e = zeros(length(L), length(quant));
for i=1:length(L)
   e(i,:) = abs(quant' - L(i));
end

[minimum,Index]=min(e);
y = L(Index);
  
y = y*2^(bits-1)+ 2^(bits-1);
  
if( size(y,1) ==1 )
     y = y';
end
y = dec2bin(y.',bits);  % converts to char string
y = reshape(y,1,size(y,1)*bits)';
y = y - 48;                % converts to numbers
