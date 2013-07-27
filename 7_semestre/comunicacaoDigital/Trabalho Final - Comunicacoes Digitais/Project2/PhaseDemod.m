function y=PhaseDemod(x, BitsPerSymbol, GrayCoding)
%function y=PhaseDemod(x, BitsPerSymbol, GrayCoding)
%
% This function demodulates M-PSK with M=2^BitsPerSymbol symbols
% This function should be used with PhaseMod.m

% preliminaries
bits = BitsPerSymbol;

M = 2^bits;

if size(x,1) ==1 
   x = x.';
end

% determine the possible signals
ss = 0:M-1;
symbols = exp(j*2*pi*ss/M);



% create the bits associated with those symbols
s = ss';

res = s;
b = zeros(M, bits);

for i=1:bits
    b(:,i) = floor(res / 2^(bits-i));
    res = res - b(:,i)*2^(bits-i);
end

% Now find the max. likelihood symbols
for i=1:M
   e(i,:) = symbols(i)-x.';
end
[minn,index] = min(abs(e));

% determine the bits associated with the symbols
y = b(index,:);

if nargin > 2
    if GrayCoding
        y_g(:,1) = y(:,1);
        for i = 2:bits
            y_g(:,i) = xor(y_g(:,i-1),y(:,i));
        end
        y = y_g;
    end
end

y = reshape(y, bits*size(y,1),1);
y = y.';

