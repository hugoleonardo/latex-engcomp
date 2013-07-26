function y = QAM16_mod(x)
% function y = QAM16_mod(x)
%
% This function modulates the data in x using QAM with 16 symbols

if size(x,1) == 1
   x = x';
end

M = 16;
l = 4;

% Determine the max/min values
L = 4;

if(mod(L,1)~=0)
   error('M must be a square!');
end

a = length(x);
z = mod(a,4);
% if( size(x,1)==a)
%   x = [x;zeros(4-z,1)];
%else
%   x = [x,zeros(1,4-z)]';
% end
a = length(x);
l;


%x = num2str(x);
size(x);
2*a/l;
l/2;
%for i=1:a/2
%   s(i,:) = x((i-1)*2+1:i*2,1).';
%end

s = reshape(x,l/2,2*a/l)';


xx = s(1:2:size(s,1),:);
yy = s(2:2:size(s,1),:);

%y = 2*bin2dec(xx)-3 +j*(2*bin2dec(yy)-3);

y = 2*(xx(:,1)*2+xx(:,2))-3 +j*(2*(yy(:,1)*2+yy(:,2))-3);


E_avg = (18+10+10+2)/4;

y = y/sqrt(E_avg);
