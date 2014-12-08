

clear all; clc;

theta = 0; % direction; 0 = 0º || 1 = 45º || 2 = 90º || 3 = 135º
D = 1; % Distance bwtween the reference and neighbor pixel to compute the GLCM
NLevels = 16; % number of gray levels to calculate the GLCM matrix
window_size = 31; % Size of the window
treshold_contrast = 0.452;
treshold_homogeneity = 0.313;
treshold_cluster = 0.346;
treshold_inertia = 0.452;
%mosaic = imread('mosaic1.png');

%mosaic = imread('mosaic2_pre_seg_2a_2c.png'); % pre-processed images
[M N] = size(mosaic); % M is the rows and N is the columns of the image

% Quantinzing the pixel's values of the pictures to 'NLevels' graylevels

for i=1:M
    for j=1:N
        if round(mosaic(i,j)/16) == 0
            mosaic(i,j) = 1;
        else
            mosaic(i,j) = round(mosaic(i,j)/16);
        end
    end
end



% ================== Features calculation =====================

glcm_win = zeros(NLevels, NLevels);
glcm_win_norm = zeros(NLevels, NLevels);
contrast = 0;
homogeneity = 0;
inertia = 0;
cluster = 0;
mean_i = 0;
mean_j = 0;

contrast_img(M-window_size,N-window_size) = 0;
contrast_tresh(M,N) = 0;
homogeneity_img(M-window_size,N-window_size) = 0;
homogeneity_tresh(M,N) = 0;
cluster_img(M-window_size,N-window_size) = 0;
cluster_tresh(M,N) = 0;
inertia_img(M-window_size,N-window_size) = 0;
inertia_tresh(M,N) = 0;
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
                    contrast = ((k-g)^2)*(glcm_win_norm(k,g)) + contrast; % contrast calculation
                    inertia = ((k-g)^2)*(glcm_win_norm(k,g)) + inertia; % inertia calculation
                    homogeneity =  (glcm_win_norm(k,g))^2 + homogeneity; % homogeneity calculation
                    mean_i = k*(glcm_win_norm(k,g)) + mean_i; % Mean x-direction calculation
                    mean_j = g*(glcm_win_norm(k,g)) + mean_j; % Mean y-direction calculation
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
                    contrast = ((k-g)^2)*(glcm_win_norm(k,g)) + contrast; % contrast calculation
                    inertia = ((k-g)^2)*(glcm_win_norm(k,g)) + inertia; % inertia calculation
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
                    inertia = ((k-g)^2)*(glcm_win_norm(k,g)) + inertia; % inertia calculation
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
                    inertia = ((k-g)^2)*(glcm_win_norm(k,g)) + inertia; % inertia calculation
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
                cluster = (((k+g-(mean_i)-(mean_j))^3)*(glcm_win_norm(k,g))) + cluster;
            end
        end
        
        contrast_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = contrast;
        homogeneity_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = homogeneity;
        cluster_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = cluster;
        inertia_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = inertia;
        
        inertia = 0;
        cluster = 0;
        contrast = 0;
        homogeneity = 0;
        mean_i = 0;
        mean_j = 0;
        
        glcm_win = zeros(NLevels, NLevels);
        glcm_win_norm = zeros(NLevels, NLevels);
    end
end

% Normalizing the GLCM contrast matrix 
contrast_img_min = min(min(contrast_img));
contrast_img_max = max(max(contrast_img));
contrast_img_norm (M-window_size,N-window_size) = 0;
for i=1:(M-window_size)
    for j=1:(N-window_size)
        contrast_img_norm(i,j) = (contrast_img(i,j)-contrast_img_min)/(contrast_img_max-contrast_img_min);
    end
end
% Filling in the blank spaces caused by the window

contrast_img_norm = padarray(contrast_img_norm,[((round(window_size/2))) ((round(window_size/2)))],0,'both');

% Computing the segmented GLCM contrast matrix
for i=1:M
    for j=1:N
        if contrast_img_norm(i,j) > treshold_contrast && contrast_img_norm(i,j) ~= 0;
        contrast_tresh(i,j) = 255;
        else if contrast_img_norm(i,j) == 0
        contrast_tresh(i,j) = 0;
            else
                contrast_img_norm(i,j) = 0;
            end
        end
    end
end

% Normalizing the GLCM homogeneity matrix 
homogeneity_img_min = min(min(homogeneity_img));
homogeneity_img_max = max(max(homogeneity_img));
homogeneity_img_norm (M-window_size,N-window_size) = 0;
for i=1:(M-window_size)
    for j=1:(N-window_size)
        homogeneity_img_norm(i,j) = (homogeneity_img(i,j)-homogeneity_img_min)/(homogeneity_img_max-homogeneity_img_min);
    end
end
% Filling in the blank spaces caused by the window

homogeneity_img_norm = padarray(homogeneity_img_norm,[((round(window_size/2))) ((round(window_size/2)))],0,'both');

% Computing the segmented GLCM homogeneity matrix
for i=1:M
    for j=1:N
        if homogeneity_img_norm(i,j) > treshold_homogeneity && homogeneity_img_norm(i,j) ~= 0;
        homogeneity_tresh(i,j) = 255;
        else if homogeneity_img_norm(i,j) == 0
        homogeneity_tresh(i,j) = 0;
            else
                homogeneity_img_norm(i,j) = 0;
            end
        end
    end
end

% Normalizing the GLCM cluster shade matrix 
cluster_img_min = min(min(cluster_img));
cluster_img_max = max(max(cluster_img));
cluster_img_norm (M-window_size,N-window_size) = 0;
for i=1:(M-window_size)
    for j=1:(N-window_size)
        cluster_img_norm(i,j) = (cluster_img(i,j)-cluster_img_min)/(cluster_img_max-cluster_img_min);
    end
end
% Filling in the blank spaces caused by the window

cluster_img_norm = padarray(cluster_img_norm,[((round(window_size/2))) ((round(window_size/2)))],0,'both');

% Computing the segmented GLCM cluster matrix
for i=1:M
    for j=1:N
        if cluster_img_norm(i,j) < treshold_cluster && cluster_img_norm(i,j) ~= 0;
        cluster_tresh(i,j) = 255;
        else if cluster_img_norm(i,j) == 0
        cluster_tresh(i,j) = 0;
            else
                cluster_img_norm(i,j) = 0;
            end
        end
    end
end

% Normalizing the GLCM inertia matrix 
inertia_img_min = min(min(inertia_img));
inertia_img_max = max(max(inertia_img));
inertia_img_norm (M-window_size,N-window_size) = 0;
for i=1:(M-window_size)
    for j=1:(N-window_size)
        inertia_img_norm(i,j) = (inertia_img(i,j)-inertia_img_min)/(inertia_img_max-inertia_img_min);
    end
end
% Filling in the blank spaces caused by the window

inertia_img_norm = padarray(inertia_img_norm,[((round(window_size/2))) ((round(window_size/2)))],0,'both');

% Computing the segmented GLCM inertia matrix
for i=1:M
    for j=1:N
        if inertia_img_norm(i,j) > treshold_inertia && inertia_img_norm(i,j) ~= 0;
        inertia_tresh(i,j) = 255;
        else if inertia_img_norm(i,j) == 0
        inertia_tresh(i,j) = 0;
            else
                inertia_img_norm(i,j) = 0;
            end
        end
    end
end

figure
ax(1) = subplot(2,2,1);
imshow(contrast_tresh); title('Contrast segmented')
ax(2) = subplot(2,2,2);
imshow(homogeneity_tresh); title('Homogeneity segmented')
ax(3) = subplot(2,2,3);
imshow(cluster_tresh); title('Cluster Shade segmented')
ax(4) = subplot(2,2,4);
imshow(inertia_tresh); title('Inertia segmented')
colormap(gray);

figure
ax(1) = subplot(2,2,1);
imshow(contrast_img_norm); title('Contrast normalized')
ax(2) = subplot(2,2,2);
imshow(homogeneity_img_norm); title('Homogeneity normalized')
ax(3) = subplot(2,2,3);
imshow(cluster_img_norm); title('Cluster Shade normalized')
ax(4) = subplot(2,2,4);
imshow(inertia_img_norm); title('Inertia normalized')
colormap(gray);

        


