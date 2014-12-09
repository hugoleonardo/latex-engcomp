function [ contrast_tresh homogeneity_tresh inertia_tresh cluster_tresh correlation_tresh] = calculate_feature(image, theta, window_size)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mosaic = imread(image);
[M N] = size(mosaic) % M is the rows and N is the columns of the image

%theta  % direction; 0 = 0º || 1 = 45º || 2 = 90º || 3 = 135º
D = 1; % Distance bwtween the reference and neighbor pixel to compute the GLCM
NLevels = 16; % number of gray levels to calculate the GLCM matrix
treshold_contrast = 0.434;
treshold_homogeneity = 0.231;
treshold_cluster = 0.578;
treshold_inertia = 0.434;

for i=1:M
    for j=1:N
        if round(mosaic(i,j)/16) == 0
            mosaic(i,j) = 1;
        else
            mosaic(i,j) = round(mosaic(i,j)/16);
        end
    end
end

% Features calculation

glcm_win = zeros(NLevels, NLevels);
glcm_win_norm = zeros(NLevels, NLevels);
contrast = 0;
homogeneity = 0;
inertia = 0;
cluster = 0;
mean_i = 0;
mean_j = 0;
dp_i = 0;
dp_j = 0;

contrast_img(M-window_size,N-window_size) = 0;
contrast_tresh(M,N) = 0;
homogeneity_img(M-window_size,N-window_size) = 0;
homogeneity_tresh(M,N) = 0;
cluster_img(M-window_size,N-window_size) = 0;
cluster_tresh(M,N) = 0;
correlation_img(M-window_size,N-window_size) = 0;
correlation_tresh(M,N) = 0;
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
                    inertia = ((k-g)^2)*(glcm_win_norm(k,g)) + inertia; % inertia calculation
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
                                dp_i = sqrt( (k - mean_i)^2*glcm_win_norm(k,g) );
                                dp_j = sqrt( (k - mean_j)^2*glcm_win_norm(k,g) );
                            end
                        end                        
                    end
                end
            end
        end
        for k=1:NLevels
            for g=1:NLevels
                cluster = (((k+g-(mean_i)-(mean_j))^3)*(glcm_win_norm(k,g))) + cluster;
                correlation = (k-mean_i)*(g-mean_j)*glcm_win_norm(k,g)/(dp_i*dp_j);
            end
        end
        
        contrast_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = contrast;
        homogeneity_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = homogeneity;
        cluster_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = cluster;
        inertia_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = inertia;
        correlation_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = correlation;
        
        inertia = 0;
        cluster = 0;
        contrast = 0;
        homogeneity = 0;
        mean_i = 0;
        mean_j = 0;
        correlation = 0;
        
        glcm_win = zeros(NLevels, NLevels);
        glcm_win_norm = zeros(NLevels, NLevels);
    end
end

% Normalizing the GLCM contrast matrix
contrast_img_norm = normaliza(contrast_img, M, N, window_size);
% Computing the segmented GLCM contrast matrix
contrast_tresh = segmenta( contrast_img_norm, M, N, treshold_contrast);
disp('Normalizou e segmentou o contraste');


% Normalizing the GLCM homogeneity matrix

homogeneity_img_norm = normaliza(homogeneity_img, M, N, window_size);

% Computing the segmented GLCM homogeneity matrix
homogeneity_tresh = segmenta( homogeneity_img_norm, M, N, treshold_homogeneity);
disp('Normalizou e segmentou a homogeneidade');


% Normalizing the GLCM cluster shade matrix
cluster_img_norm = normaliza(cluster_img, M, N, window_size);

% Normalizing the GLCM correlation matrix
correlation_img_norm = normaliza(correlation_img, M, N, window_size);

% Computing the segmented GLCM cluster matrix
cluster_tresh = segmenta( cluster_img_norm, M, N, treshold_cluster);
disp('Normalizou e segmentou o cluster shade');

% Computing the segmented GLCM correlation matrix
correlation_tresh = segmenta( correlation_img_norm, M, N, treshold_cluster);
disp('Normalizou e segmentou o correlacao');

% Normalizing the GLCM inertia matrix
inertia_img_norm = normaliza(inertia_img, M, N, window_size);

% Computing the segmented GLCM inertia matrix
inertia_tresh = segmenta( inertia_img_norm, M, N, treshold_inertia);



end

