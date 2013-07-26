function y = QAM16_demod(x)
% function y = QAM16_demod(x)
%
% This function modulates the data in x using QAM with 16 symbols


M = 16;
bits = 4;

for i=0:15
   a = floor(i/4);
   b = mod(i,4);
   y(i+1) = 2*(a)-3 +j*(2*(b)-3);
end

E_avg = (18+4+4+2)/4;

symbols = y/sqrt(E_avg);

for i=1:M
   e(i,:) = symbols(i)-x.';
end


[minn,index] = min(abs(e));
b = [0,0,0,0;
        0,0,0,1;
        0,0,1,0;
        0,0,1,1;
        0,1,0,0;
        0,1,0,1;
        0,1,1,0;
        0,1,1,1;
        1,0,0,0;
        1,0,0,1;
        1,0,1,0;
        1,0,1,1;
        1,1,0,0;
        1,1,0,1;
        1,1,1,0;
        1,1,1,1;];

y = b(index,:);
y = reshape(y.', bits*size(y,1),1);
y = y.';

%y = str2num(y).';





