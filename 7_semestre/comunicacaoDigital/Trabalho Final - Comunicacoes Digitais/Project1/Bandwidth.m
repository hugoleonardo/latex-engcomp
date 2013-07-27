function bw = Bandwidth( x, f_s, threshold)
% function bw = Bandwidth( x, f_s, threshold)
%
% This function calculates the bandwidth of the signal x
% that contains 100*threshold % of the signal energy.
% Example threshold = 0.99 --> Bandwidth( x, f_s, 0.99 ) calculates the bandwidth which contains 99% of the energy
% x is a time waveform sampled at rate f_s.

X = fft(x);
X = X(1:length(x)/2);

%threshold = 1-threshold;

E = cumsum(abs(X).^2);

energy = E(length(X));


[a,b] = min(abs(E/energy-threshold));

bw = b*f_s/(2*length(X));

