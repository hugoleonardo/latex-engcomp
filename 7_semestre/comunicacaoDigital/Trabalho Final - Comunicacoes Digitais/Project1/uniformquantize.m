function y = UniformQuantize(x, levels)
% function y = UniformQuantize(x, levels)
%
% This function creates a vector y which is a quantized version of the input x.
% A uniform quantizer is used with 'levels' number of levels.  The input is assumed
% to be normalized to be between -1 and +1

L = -1+2/levels/2:2/levels:1;

e = zeros(length(L), length(x));

for i=1:length(L)
   
   e(i,:) = abs(x' - L(i));
end
[minimum,Index]=min(e);
%   y(i) = L(Index);
  
  y = L(Index);
  
  if size(x,1) ~= size(y,1);
     y = y.';
  end