function [ contrast_img_norm, homogeneity_img_norm, energy_img_norm, inv_dif_img_norm, inv_dif_mom_img_norm, dissimilarity_img_norm, cluster_shade_img_norm, cluster_prominence_img_norm, correlation_img_norm, entropy_img_norm, max_prob_img_norm, soma_avg_img_norm, soma_entropia_img_norm, soma_variancia_img_norm, diferenca_entropia_img_norm, diferenca_variancia_img_norm ] = calculate_feature_danilo(image, theta, window_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mosaic = imread(image);
[M, N] = size(mosaic); % M is the rows and N is the columns of the image

%theta  % direction; 0 = 0º || 1 = 45º || 2 = 90º || 3 = 135º
D = 1; % Distance bwtween the reference and neighbor pixel to compute the GLCM
NLevels = 16; % number of gray levels to calculate the GLCM matrix
cte = 0.36; % COnstante usada no cálculo da Entropia log(0.36) ~= 1
%treshold_contrast = 0.434;
%treshold_homogeneity = 0.231;
%treshold_cluster = 0.578;
%treshold_energy = 0.434;

for i=1:M
    for j=1:N
        if round(mosaic(i,j)/NLevels) == 0
            mosaic(i,j) = 1;
        else
            mosaic(i,j) = round(mosaic(i,j)/NLevels);
        end
    end
end

% Features calculation

soma_temp = 0;
diferenca_temp = 0;
soma_avg = 0;
soma_entropia = 0;
soma_variancia = 0;
diferenca_media = 0;
diferenca_variancia = 0;
diferenca_entropia = 0;
soma = zeros(1,2*NLevels);
diferenca = zeros(1,NLevels);
glcm_win = zeros(NLevels, NLevels);
glcm_win_norm = zeros(NLevels, NLevels);
contrast = 0;
contrast_temp = 0;
correlation = 0;
homogeneity = 0;
dissimilarity = 0;
energy = 0;
inv_dif = 0;
inv_dif_mom = 0;
cluster_shade = 0;
cluster_prominence = 0;
correlation = 0;
entropy = 0;
max_prob = 0;
mean_i = 0;
mean_j = 0;
dp_i = 0;
dp_j = 0;

%%%% Declaração das matrizes que irão receber as imagens para cada
%%%% característica
soma_avg_img(M-window_size,N-window_size) = 0;
soma_entropia_img(M-window_size,N-window_size) = 0;
soma_variancia_img(M-window_size,N-window_size) = 0;
diferenca_variancia_img(M-window_size,N-window_size) = 0;
diferenca_entropia_img(M-window_size,N-window_size) = 0;
contrast_img(M-window_size,N-window_size) = 0;
inv_dif_img(M-window_size,N-window_size) = 0;
inv_dif_mom_img(M-window_size,N-window_size) = 0;
dissimilarity_img(M-window_size,N-window_size) = 0;
homogeneity_img(M-window_size,N-window_size) = 0;
cluster_shade_img(M-window_size,N-window_size) = 0;
cluster_prominence_img(M-window_size,N-window_size) = 0;
correlation_img(M-window_size,N-window_size) = 0;
energy_img(M-window_size,N-window_size) = 0;
entropy_img(M-window_size,N-window_size) = 0;
max_prob_img(M-window_size,N-window_size) = 0;
%Calculating the GLCM matrix using window
for i=round(window_size/2):M-(round(window_size/2)-1)
    for j=round(window_size/2):N-(round(window_size/2)-1)
        if theta == 0
            for m=1:window_size-1
                for n=D:window_size-1-D
                    %glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n)),(mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n+D))) = glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n)),(mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n+D))) + 1;
                    r = (mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n));
                    s = (mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n+D));
                    glcm_win(r,s) = glcm_win(r,s) + 1;
                end
            end
            % Computing the symmetric and normalized, respectively,
            % matrices of the GLCM matrix
            glcm_T = glcm_win.';
            glcm_win_sym = glcm_win + glcm_T; % symmetric
            % Calculating the normalized GLCM matrix and unsing these
            % values to calculate the features of the matrix
            for k=1:NLevels
                for g=1:NLevels
                    glcm_win_norm(k,g) = glcm_win_sym(k,g)/(sum(sum(glcm_win_sym))); % normalized
                    contrast_temp = (glcm_win_norm(k,g)) + contrast_temp; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g) + dissimilarity; % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
                    dp_i = sqrt( (k - mean_i)^2*glcm_win_norm(k,g) ) + dp_i;
                    dp_j = sqrt( (g - mean_j)^2*glcm_win_norm(k,g) ) + dp_j;
                    entropy = (glcm_win_norm(k,g)*log(glcm_win_norm(k,g)+cte)) + entropy; % entropy calculation
                    soma_temp = glcm_win_norm(k,g) + soma_temp;
                    soma(1,k+g) = soma_temp;
                    diferenca_temp = glcm_win_norm(k,g) + diferenca_temp;
                    diferenca(1,abs(k-g)+1) = diferenca_temp;
                end
            end
        else if theta == 1
            for m=1+D:window_size-1
                for n=D:window_size-1-D
                    %glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n-D)),(mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n+D))) = glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n-D)),(mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n+D))) + 1;
                    r = (mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n));
                    s = (mosaic(((i-round(window_size/2))+m-D), (j-round(window_size/2))+n+D));
                    glcm_win(r,s) = glcm_win(r,s) + 1;
                end
            end
            % Computing the symmetric and normalized, respectively,
            % matrices of the GLCM matrix
            glcm_T = glcm_win.';
            glcm_win_sym = glcm_win + glcm_T; % symmetric
            % Calculating the normalized GLCM matrix and unsing these
            % values to calculate the features of the matrix
            for k=1:NLevels
                for g=1:NLevels
                    glcm_win_norm(k,g) = glcm_win_sym(k,g)/(sum(sum(glcm_win_sym))); % normalized
                    contrast_temp = (glcm_win_norm(k,g)) + contrast_temp; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g) + dissimilarity; % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
                    dp_i = sqrt( (k - mean_i)^2*glcm_win_norm(k,g) ) + dp_i;
                    dp_j = sqrt( (g - mean_j)^2*glcm_win_norm(k,g) ) + dp_j;
                    entropy = glcm_win_norm(k,g)*log(glcm_win_norm(k,g)+cte) + entropy; % entropy calculation
                    soma_temp = glcm_win_norm(k,g) + soma_temp;
                    soma(1,k+g) = soma_temp;
                    diferenca_temp = glcm_win_norm(k,g) + diferenca_temp;
                    diferenca(1,abs(k-g)+1) = diferenca_temp;
                end
            end
        else if theta == 2
            for m=1+D:window_size-1
                for n=1:window_size
                    %glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n-D)),(mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n))) = glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n-D)),(mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n))) + 1;
                    r = (mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n));
                    s = (mosaic(((i-round(window_size/2))+m-D), (j-round(window_size/2))+n));
                    glcm_win(r,s) = glcm_win(r,s) + 1;
                end
            end
            % Computing the symmetric and normalized, respectively,
            % matrices of the GLCM matrix
            glcm_T = glcm_win.';
            glcm_win_sym = glcm_win + glcm_T; % symmetric
            % Calculating the normalized GLCM matrix and unsing these
            % values to calculate the features of the matrix
            for k=1:NLevels
                for g=1:NLevels
                    glcm_win_norm(k,g) = glcm_win_sym(k,g)/(sum(sum(glcm_win_sym))); % normalized
                    contrast_temp = (glcm_win_norm(k,g)) + contrast_temp; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g) + dissimilarity; % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
                    dp_i = sqrt( (k - mean_i)^2*glcm_win_norm(k,g) ) + dp_i;
                    dp_j = sqrt( (g - mean_j)^2*glcm_win_norm(k,g) ) + dp_j;
                    entropy = glcm_win_norm(k,g)*log(glcm_win_norm(k,g)+cte) + entropy; % entropy calculation
                    soma_temp = glcm_win_norm(k,g) + soma_temp;
                    soma(1,k+g) = soma_temp;
                    diferenca_temp = glcm_win_norm(k,g) + diferenca_temp;
                    diferenca(1,abs(k-g)+1) = diferenca_temp;
                end
            end 
        else if theta == 3
            for m=1+D:window_size-1
                for n=1+D:window_size
                    %glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n-D)),(mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n+D))) = glcm_win((mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n-D)),(mosaic(((i-round(window_size/2))+m), (j-round(window_size/2))+n+D))) + 1;
                    r = (mosaic((i-round(window_size/2))+m, (j-round(window_size/2))+n));
                    s = (mosaic(((i-round(window_size/2))+m-D), (j-round(window_size/2))+n-D));
                    glcm_win(r,s) = glcm_win(r,s) + 1;
                end
            end
            % Computing the symmetric and normalized, respectively,
            % matrices of the GLCM matrix
            glcm_T = glcm_win.';
            glcm_win_sym = glcm_win + glcm_T; % symmetric
            % Calculating the normalized GLCM matrix and unsing these
            % values to calculate the features of the matrix
            for k=1:NLevels
                for g=1:NLevels
                    glcm_win_norm(k,g) = glcm_win_sym(k,g)/(sum(sum(glcm_win_sym))); % normalized
                    contrast_temp = (glcm_win_norm(k,g)) + contrast_temp; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g) + dissimilarity; % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
                    dp_i = sqrt( (k - mean_i)^2*glcm_win_norm(k,g) ) + dp_i;
                    dp_j = sqrt( (g - mean_j)^2*glcm_win_norm(k,g) ) + dp_j;
                    entropy = glcm_win_norm(k,g)*log(glcm_win_norm(k,g)+cte) + entropy; % entropy calculation
                    soma_temp = glcm_win_norm(k,g) + soma_temp;
                    soma(1,k+g) = soma_temp;
                    diferenca_temp = glcm_win_norm(k,g) + diferenca_temp;
                    diferenca(1,abs(k-g)+1) = diferenca_temp;
                end
            end 
            end
            end
            end
        end
        for k=1:NLevels
            for g=1:NLevels
                cluster_shade = (((k+g-(mean_i)-(mean_j))^3)*(glcm_win_norm(k,g))) + cluster_shade;
                cluster_prominence = (((k+g-(mean_i)-(mean_j))^4)*(glcm_win_norm(k,g))) + cluster_prominence;
                correlation = ((k-mean_i)*(g-mean_j)*glcm_win_norm(k,g))/(dp_i*dp_j) + correlation;
                contrast = ((abs(k-g))^2)*contrast_temp + contrast;
            end
        end
        
        
        for p=2:2*NLevels
            soma_avg = (p*(soma(1,p))) + soma_avg;
            soma_entropia = (soma(1,p)*log((soma(1,p))+cte)) + soma_entropia;
            soma_variancia = ((p - soma_entropia)^2)*soma(1,p) +  soma_variancia;
        end
        
        for p=1:NLevels
            diferenca_entropia = (diferenca(1,p)*log(diferenca(1,p)+cte)) + diferenca_entropia;
            diferenca_media = p*diferenca(1,p) + diferenca_media;
        end
        
        for p=1:NLevels
            diferenca_variancia = ((p-diferenca_media)^2)*diferenca(1,p) + diferenca_variancia;
        end
        
        max_prob = max(max(glcm_win_norm));
        
        
        contrast_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = contrast;
        homogeneity_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = homogeneity;
        dissimilarity_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = dissimilarity;
        cluster_shade_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = cluster_shade;
        cluster_prominence_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = cluster_prominence;
        correlation_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = correlation;
        energy_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = energy;
        inv_dif_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = inv_dif;
        inv_dif_mom_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = inv_dif_mom;     
        entropy_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = entropy;
        max_prob_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = max_prob;
        soma_avg_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = soma_avg;
        soma_entropia_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = soma_entropia;
        soma_variancia_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = soma_variancia;
        diferenca_entropia_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = diferenca_entropia;
        diferenca_variancia_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = diferenca_variancia;
        
        energy = 0;
        inv_dif = 0;
        inv_dif_mom = 0;
        dissimilarity = 0;
        cluster_shade = 0;
        cluster_prominence = 0;
        contrast = 0;
        contrast_temp = 0;
        homogeneity = 0;
        mean_i = 0;
        mean_j = 0;
        dp_i = 0;
        dp_j = 0;
        entropy = 0;
        correlation = 0;
        max_prob = 0;
        soma_temp = 0;
        diferenca_temp = 0;
        soma_avg = 0;
        soma_entropia = 0;
        soma_variancia = 0;
        diferenca_entropia = 0;
        diferenca_variancia = 0;
        diferenca_media = 0;
        
        glcm_win = zeros(NLevels, NLevels);
        glcm_win_norm = zeros(NLevels, NLevels);
    end
end

% Normalizing the GLCM contrast matrix 
contrast_img_norm = normaliza(contrast_img);
contrast_img_norm(M,N) = 0;
imshow(contrast_img_norm);
imwrite(contrast_img_norm, 'mosaic6_theta0_window5_contrast.png');

% Normalizing the GLCM homogeneity matrix 
homogeneity_img_norm = normaliza(homogeneity_img);
homogeneity_img_norm(M,N)=0;
imwrite(homogeneity_img_norm, 'mosaic6_theta0_window5_homogeneity.png');

% Normalizing the GLCM cluster shade shade matrix 
cluster_shade_img_norm = normaliza(cluster_shade_img);
cluster_shade_img_norm(M,N)=0;
imwrite(cluster_shade_img, 'mosaic6_theta0_window5_cluster_shade.png');

% Normalizing the GLCM cluster prominence matrix 
cluster_prominence_img_norm = normaliza(cluster_prominence_img);
cluster_prominence_img_norm(M,N)=0;
imwrite(cluster_prominence_img, 'mosaic6_theta0_window5_cluster_prominence.png');

% Normalizing the GLCM correlation matrix
correlation_img_norm = normaliza(correlation_img);
correlation_img_norm(M,N)=0;
imwrite(correlation_img_norm, 'mosaic6_theta0_window5_correlation.png');

% Normalizing the GLCM energy matrix 
energy_img_norm = normaliza(energy_img);
energy_img_norm(M,N)=0;
imwrite(energy_img_norm, 'mosaic6_theta0_window5_energy_img.png');

% Normalizing the GLCM dissimilarity matrix 
dissimilarity_img_norm = normaliza(dissimilarity_img);
dissimilarity_img_norm(M,N)=0;
imwrite(dissimilarity_img_norm, 'mosaic6_theta0_window5_dissimilarity.png');

% Normalizing the GLCM inverse difference matrix 
inv_dif_img_norm = normaliza(inv_dif_img);
inv_dif_img_norm(M,N)=0;
imwrite(inv_dif_img_norm, 'mosaic6_theta0_window5_inv_dif.png');

% Normalizing the GLCM inverse difference moment matrix 
inv_dif_mom_img_norm = normaliza(inv_dif_mom_img);
inv_dif_mom_img_norm(M,N)=0;
imwrite(inv_dif_mom_img_norm, 'mosaic6_theta0_window5_inv_dif_mom.png');

% Normalizing the GLCM entropy matrix 
entropy_img_norm = normaliza(entropy_img);
entropy_img_norm(M,N)=0;
imwrite(entropy_img_norm, 'mosaic6_theta0_window5_entropy.png');

% Normalizing the GLCM max probability matrix 
max_prob_img_norm = normaliza(max_prob_img);
max_prob_img_norm(M,N)=0;
imwrite(max_prob_img_norm, 'mosaic6_theta0_window5_max_prob.png');

% Normalizing the GLCM sum average matrix 
soma_avg_img_norm = normaliza(soma_avg_img);
soma_avg_img_norm(M,N)=0;
imwrite(soma_avg_img_norm, 'mosaic6_theta0_window5_soma_avg.png');

% Normalizing the GLCM sum entropy matrix 
soma_entropia_img_norm = normaliza(soma_entropia_img);
soma_entropia_img_norm(M,N) =0;
imwrite(soma_entropia_img_norm, 'mosaic6_theta0_window5_soma_entropia.png');

% Normalizing the GLCM difference entropy matrix 
diferenca_entropia_img_norm = normaliza(diferenca_entropia_img);
diferenca_entropia_img_norm(M,N)=0;
imwrite(diferenca_entropia_img_norm, 'mosaic6_theta0_window5_diferenca_entropia.png');

% Normalizing the GLCM sum entropy matrix 
soma_variancia_img_norm = normaliza(soma_variancia_img);
soma_variancia_img_norm(M,N) =0;
imwrite(soma_variancia_img_norm, 'mosaic6_theta0_window5_soma_variancia.png');

% Normalizing the GLCM sum entropy matrix 
diferenca_variancia_img_norm = normaliza(diferenca_variancia_img);
diferenca_variancia_img_norm(M,N) =0;
imwrite(diferenca_variancia_img_norm, 'mosaic6_theta0_window5_diferenca_variancia.png');
end

