clear; clc;

n = 249;
%y0 = peaks(n);
y0 = im2double(imread('mosaic3_window5_smoothed_contrast.png'));
y = y0;% + rand(size(y0))*2;
I = randperm(n^2);
%y(I(1:n^2*0.5)) = NaN; % lose 1/2 of data
%y(40:90,140:190) = NaN; % create a hole
z = smoothn(y); % smooth data
%subplot(2,2,1:2), imagesc(y), axis equal off
%subplot(2,2,1:2), imshow(y,[]), axis equal off
%title('Noisy corrupt data')
%subplot(223), imagesc(z), axis equal off
subplot(223), imshow(z,[]), axis equal off
title('Recovered data ...')
%subplot(224), imagesc(y0), axis equal off
subplot(224), imshow(y0,[]), axis equal off
title('... compared with original data')