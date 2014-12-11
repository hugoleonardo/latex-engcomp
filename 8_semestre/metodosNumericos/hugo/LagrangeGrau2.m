function [out] = LagrangeGrau2(x, xi, y);
%clear; clc;
%x = zeros(1,3);
%y = zeros(1,3);

%for i=1:3
%    fprintf('Digite o x%d\n',i);
%    x(1,i) = input('');
%end
x
%fprintf('Digite o valor inicial de x\n');
%xi = input('');

%for i=1:3
%    fprintf('Digite o valor de y%d\n',i);
%    y(1,i) = input('');
%end

l0 = ((xi-x(1,2))/(x(1,1)-x(1,2)))*((xi-x(1,3))/(x(1,1)-x(1,3)));
l1 = ((xi-x(1,1))/(x(1,2)-x(1,1)))*((xi-x(1,3))/(x(1,2)-x(1,3)));
l2 = ((xi-x(1,1))/(x(1,3)-x(1,1)))*((xi-x(1,2))/(x(1,3)-x(1,2)));

out = (y(1,1)*l0)+(y(1,2)*l1)+(y(1,3)*l2);