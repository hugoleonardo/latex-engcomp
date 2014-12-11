
clear;clc;
p = rand(4)
p1=0;
%p1 = zeros(4,1);
p2(8) = 0;

for i=1:4
    for j=1:4
        p1 = p(i,j) + p1;
        p2(1,i+j) = p1
    end
end
