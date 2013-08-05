load DesignProject1

f_s = 65536;
f_s1 = 65536/4;
f_s2 = 65536/8;
f_s3 = 65536/16;
f_s4 = 65536/32;

x0 = Original;
x1 = sample(Original, f_s1);
x2 = sample(Original, f_s2);
x3 = sample(Original, f_s3);
x4 = sample(Original, f_s4);

y0_64 = uniformquantize(x0,64);
y1_64 = uniformquantize(x1,64);
y2_64 = uniformquantize(x2,64);
y3_64 = uniformquantize(x3,64);
y4_64 = uniformquantize(x4,64);

interpx0 = interp(x0,1);
interpx1 = interp(x1,4);
interpx2 = interp(x2,8);
interpx3 = interp(x3,16);
interpx4 = interp(x4,32);

x0x0 = interpx0 - x0;
x0x1 = interpx1 - x0;
x0x2 = interpx2 - x0;
x0x3 = interpx3 - x0;
x0x4 = interpx4 - x0;
x0x42 = x0 - interpx4;

%EnergySpectralDensity(x, f_s);hold;
bw0 = Bandwidth( x0, f_s, 0.99);
bw1 = Bandwidth( x1, f_s1, 0.99);
bw2 = Bandwidth( x2, f_s2, 0.99);
bw3 = Bandwidth( x3, f_s3, 0.99);
bw4 = Bandwidth( x4, f_s4, 0.99);