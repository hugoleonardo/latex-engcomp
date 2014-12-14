function [coeff, score] = noise_reduction_danilo
%UNTITLED Summary of this function goes here
%   Noise reduciton as descrideb in the article

    %imagem = imread(imagem1);
    %[M,N] = size(imagem);
    %imagem = im2double(imagem);
    %imagem = 128 - imagem;
    %imagem = normaliza(imagem,M ,N);

    tmp = imread('mosaic3_window5_smoothed_cluster_prominence.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(1,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_cluster_shade.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(2,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_contrast.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(3,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_correlation.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(4,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_diferenca_entropia.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(5,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_diferenca_variancia.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(6,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_dissimilarity.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(7,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_energy.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(8,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_entropy.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(9,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_homogeneity.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(10,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_inv_dif.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(11,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_inv_dif_mom.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(12,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_max_prob.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(13,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_soma_avg.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(14,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_soma_entropia.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(15,:) = tmp(:);
    
    tmp = imread('mosaic3_window5_smoothed_soma_variancia.png');
    tmp(256,256)=0;
    tmp = dct2(tmp);
    tmp = idct2(tmp);
    pca(16,:) = tmp(:);
    
    [coeff, score] = princomp(pca');
    
    disp('maoe');
end

