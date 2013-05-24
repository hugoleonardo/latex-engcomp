% (funct_tri.m)
% Fun��o triangular, com base de -1 a 1
function y = funct_tri(t)
% Uso y = funct_tri(t)
%   t = vari�vel de entrada i
y = ((t>-1) - (t>1)) .* (1-abs(t));