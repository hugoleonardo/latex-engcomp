function [out] = LagrangeGrau2(x, xi, y)

L0 = ( (x-xi(1,2))/(xi(1,1)-xi(1,2)) )*( (x-xi(1,3))/(xi(1,1)-xi(1,3)) );
L1 = ( (x-xi(1,1))/(xi(1,2)-xi(1,1)) )*( (x-xi(1,3))/(xi(1,2)-xi(1,3)) );
L2 = ( (x-xi(1,1))/(xi(1,3)-xi(1,1)) )*( (x-xi(1,2))/(xi(1,3)-xi(1,2)) );

out = (y(1,1)*L0)+(y(1,2)*L1)+(y(1,3)*L2);