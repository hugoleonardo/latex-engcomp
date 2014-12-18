function [coeff, score] = noise_reduction_danilo
%UNTITLED Summary of this function goes here
%   Noise reduciton as descrideb in the article

    %imagem = imread(imagem1);
    %[M,N] = size(imagem);
    %imagem = im2double(imagem);
    %imagem = 128 - imagem;
    %imagem = normaliza(imagem,M ,N);

    tmp = imread('mosaic6_window5_smoothed_cluster_prominence.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(1,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_cluster_shade.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(2,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_soma_variancia.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(3,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_correlation.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(4,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_diferenca_entropia.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(5,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_diferenca_variancia.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(6,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_dissimilarity.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(7,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_energy.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(8,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_entropy.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(9,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_homogeneity.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(10,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_inv_dif.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(11,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_inv_dif_mom.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(12,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_max_prob.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(13,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_soma_avg.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(14,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_soma_entropia.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(15,:) = tmp(:);
    
    tmp = imread('mosaic6_window5_smoothed_contrast.png');
    tmp(128,128)=0;
    %tmp = dct2(tmp);
    %tmp = idct2(tmp);
    pcamat(16,:) = tmp(:);
    %plot(tmp);
    
    %pcamat(17,:) = 0;
    %plot(pcamat(17,:));
    %pcamat2 = pcamat';
    
    %[coeff, score] = princomp(pcamat2);
    %[~,score] = pca(pcamat2,'NumComponents',16);
    [signal, PC, V] = pca2(im2double(pcamat));
    
    
    %options = statset('Display','off');
    signal(16,:) = [];
    signal = signal';
    obj = fitgmdist(signal,4,'SharedCov',true,'CovType','diagonal');
    idx = cluster(obj,signal);
 
    im = imread('mosaic6.png');
    imteste(:,1) = im(:);
    [m,n] = size(im);
    
    imteste2 = reshape(idx,[128,128]);
    imteste2 = normaliza(imteste2);
    figure;
    imshow(im);
    figure;
    imshow(imteste2);
    
    disp('maoe');
end

