function y = sample( x, f_s, f_s_original )

% function y = sample( x, f_s, f_s_original)
%
% This function creates a "sampled" version of the input vector x using a rate of f_s samples per second.
% It is assumed that the input vector x is originally sampled at a rate of 65,536 samples per second unless 
% f_s_original is specified.  Note that f_s_original is an optional input and is the sample rate of the input vector
% x.  If the original sampling rate of x is 65536 f_s_original need not be
% specified.


if nargin < 3
    f_s_original = 65536;
end


if rem( f_s_original, f_s ) == 0
    y = x(1:f_s_original / f_s:length(x));
elseif f_s_original / f_s > 1
    y = decimate( x, f_s_original / f_s );
else
    y = interp( x, f_s_original / f_s );
end
