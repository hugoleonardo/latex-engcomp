function [  ] = suaviza()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    img = imread('mosaic5_window5_smoothed_cluster_prominence.png');
    suave = smoothn(img,'robust');
    imwrite(suave, 'mosaic5_window5_smoothed_cluster_prominence.png');
    
    
    
    
end

