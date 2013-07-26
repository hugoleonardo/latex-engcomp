function y=Digital2Analog( x, NumBits, companding, mu)
%function y=Digital2Analog( x, NumBits, companding, mu)
%
% This function creates a numerical valued signal from a string of bits
% assuming that NumBits per quantization level are used.  
% Further, it is assumed that the levels are evenly distributed about zero.

if(size(x,1) == 1)
   x = x.';
end

a = length(x);
%x = num2str(x);
b = reshape(x, a/NumBits, NumBits);
size(x)
size(b)

%z = bin2dec(b);

y = zeros(a/NumBits,1);

for i=1:NumBits
   y = y + 2^(NumBits-i)*b(:,i);
end
y = y - 2^(NumBits-1);


y = y/(2^(NumBits-1)) + 1/(2^NumBits);
y = y.';

if nargin < 3
    companding = 0;
end
if companding 
    y = expand(y, mu);
end

