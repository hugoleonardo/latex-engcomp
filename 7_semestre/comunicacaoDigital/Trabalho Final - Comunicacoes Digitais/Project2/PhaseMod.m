function y = PhaseMod(x, BitsPerSymbol, GrayCoding)
% function y = PhaseMod(x, BitsPerSymbol, GrayCoding)
%
% This function performs phase modulation using l bits per symbol.  Thus the
% modulation is (2^BitPerSymbol)-PSK.  The the input vector should be deimal or binary.
% The return vector y is complex baseband.
%
%  x is the input bit vector where each element is in {0,1}
%  BitsPerSymbol is 1 for BPSK, 2 for QPSK, etc.
%  If GrayCoding == 1, Gray Coding is used. If GrayCoding == 0, Gray Coding
%  is NOT used.

l=BitsPerSymbol;
bits = BitsPerSymbol;

if rem( length(x), bits) ~= 0
    error('Input vector x must have length bits*k where k is an integer')
end

M = 2^l;

if size(x,1)==1
   x = x.';
end

a = size(x,1);

b = reshape(x,a/l,l);

if nargin > 2
    if GrayCoding & bits > 1
        b_g(:,1) = b(:,1);
        for i = 2:bits
            b_g(:,i) = xor(b(:,i-1), b(:,i));
        end
        b = b_g;
    end
end


power_of_two = 2.^([bits-1:-1:0]);

s = zeros(length(x)/bits, 1);

for i=1:bits
    s = s + power_of_two(i)*b(:,i);
end


y = exp(j*2*pi*s/M);

