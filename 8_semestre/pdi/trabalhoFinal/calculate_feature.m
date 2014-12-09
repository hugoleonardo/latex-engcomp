function [ contrast_img_norm, homogeneity_img_norm, energy_img_norm, inv_dif_img_norm, inv_dif_mom_img_norm, dissimilarity_img_norm, cluster_shade_img_norm, cluster_prominence_img_norm ] = calculate_feature(image, theta, window_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mosaic = imread(image);
[M N] = size(mosaic) % M is the rows and N is the columns of the image

%theta  % direction; 0 = 0º || 1 = 45º || 2 = 90º || 3 = 135º
D = 1; % Distance bwtween the reference and neighbor pixel to compute the GLCM
NLevels = 16; % number of gray levels to calculate the GLCM matrix
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

glcm_win = zeros(NLevels, NLevels);
glcm_win_norm = zeros(NLevels, NLevels);
contrast = 0;
homogeneity = 0;
dissimilarity = 0;
energy = 0;
inv_dif = 0;
inv_dif_mom = 0;
cluster_shade = 0;
cluster_prominence = 0;
mean_i = 0;
mean_j = 0;

contrast_img(M-window_size,N-window_size) = 0;
inv_dif_img(M-window_size,N-window_size) = 0;
inv_dif_mom_img(M-window_size,N-window_size) = 0;
dissimilarity_img(M-window_size,N-window_size) = 0;
homogeneity_img(M-window_size,N-window_size) = 0;
cluster_shade_img(M-window_size,N-window_size) = 0;
cluster_prominence_img(M-window_size,N-window_size) = 0;
energy_img(M-window_size,N-window_size) = 0;

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
            disp('Calculou GLCM de um pixel da imagem');
            % Computing the symmetric and normalized, respectively,
            % matrices of the GLCM matrix
            glcm_T = glcm_win.';
            glcm_win_sym = glcm_win + glcm_T; % symmetric
            % Calculating the normalized GLCM matrix and unsing these
            % values to calculate the features of the matrix
            for k=1:NLevels
                for g=1:NLevels
                    glcm_win_norm(k,g) = glcm_win_sym(k,g)/(sum(sum(glcm_win_sym))); % normalized
                    contrast = ((k-g)^2)*(glcm_win_norm(k,g)) + contrast; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g); % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
                end
            end
            disp('Normalizou o pixel e calculou as caracteristicas');
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
                    contrast = ((k-g)^2)*(glcm_win_norm(k,g)) + contrast; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g); % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
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
                    contrast = ((k-g)^2)*(glcm_win_norm(k,g)) + contrast; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g); % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
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
                    contrast = ((k-g)^2)*(glcm_win_norm(k,g)) + contrast; % contrast calculation
                    dissimilarity = abs(k-g)*glcm_win_norm(k,g); % dissimilarity calculation
                    energy = (glcm_win_norm(k,g)^2) + energy; % energy calculation
                    inv_dif = (glcm_win_norm(k,g)/(1+abs(k-g))) + inv_dif; % inverse difference calculation
                    inv_dif_mom = (glcm_win_norm(k,g)/(1+(k-g)^2)) + inv_dif_mom; % inverse difference moment calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
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
            end
        end
        
        
        
        contrast_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = contrast;
        homogeneity_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = homogeneity;
        dissimilarity_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = dissimilarity;
        cluster_shade_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = cluster_shade;
        cluster_prominence_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = cluster_prominence;
        energy_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = energy;
        inv_dif_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = inv_dif;
        inv_dif_mom_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = inv_dif_mom;
        
        energy = 0;
        inv_dif = 0;
        inv_dif_mom = 0;
        dissimilarity = 0;
        cluster_shade = 0;
        cluster_prominence = 0;
        contrast = 0;
        homogeneity = 0;
        mean_i = 0;
        mean_j = 0;
        
        glcm_win = zeros(NLevels, NLevels);
        glcm_win_norm = zeros(NLevels, NLevels);
    end
end

% Normalizing the GLCM contrast matrix 
contrast_img_norm = normaliza(contrast_img, M, N, window_size);
disp('Normalizou o contraste');


% Normalizing the GLCM homogeneity matrix 
homogeneity_img_norm = normaliza(homogeneity_img, M, N, window_size);
disp('Normalizou a homogeneidade');


% Normalizing the GLCM cluster shade shade matrix 
cluster_shade_img_norm = normaliza(cluster_shade_img, M, N, window_size);
disp('Normalizou o cluster shade');

% Normalizing the GLCM cluster prominence shade matrix 
cluster_prominence_img_norm = normaliza(cluster_prominence_img, M, N, window_size);
disp('Normalizou o cluster prominence');

% Normalizing the GLCM energy matrix 
energy_img_norm = normaliza(energy_img, M, N, window_size);
disp('Normalizou a energia');

% Normalizing the GLCM dissimilarity matrix 
dissimilarity_img_norm = normaliza(dissimilarity_img, M, N, window_size);
disp('Normalizou a energia');

% Normalizing the GLCM inverse difference matrix 
inv_dif_img_norm = normaliza(inv_dif_img, M, N, window_size);
disp('Normalizou a diferença inversa');

% Normalizing the GLCM inverse difference moment matrix 
inv_dif_mom_img_norm = normaliza(inv_dif_mom_img, M, N, window_size);
disp('Normalizou o momento da diferença inversa');

end

