function [Y,f] = EnergySpectralDensity(x, fs,range,logplot)
% function EnergySpectralDensity(x, fs,range, logplot)
% this function plots the energy spectrum of the vector x given a sampling rate fs.
%
% The optional variable 'range' gives the x and y axis ranges
% The input should be of the form range =[x_min x_max y_min y_max]
% if logplot = 1, the function will plot in log domain.  If logplot is
% undefined, it defaults to 0.

if nargin < 4
    logplot = 0;
end
X = fft(x);

figure
f = -fs/2+fs/length(x):fs/length(x):fs/2;
if size(X,1) ~= 1
    X = X.';
end
Y = [X((length(X)/2+1):end),X(1:length(X)/2)];
if length(Y) < length(f)
        Y = [Y,0];
end


if logplot
    plot(f, 20*log10(abs(Y)/max(abs(Y))))
    if nargin < 3
        axis([-fs/2 fs/2 -50 max(abs(X).^2)])
    else
        axis(range)
    end
else
    plot(f, abs(Y).^2)
    if nargin < 3
        axis([-fs/2 fs/2 0 max(abs(X).^2)])
    else
        axis(range)
    end
end
xlabel('Frequency (Hz)')
ylabel('Magnitude Spectrum')


