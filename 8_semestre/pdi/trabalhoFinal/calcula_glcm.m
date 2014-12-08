function [ feature_img ] = calcula_glcm(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    % Parameters: mosaic, theta, quad, subquad(when necessary)
    mosaic = varargin{1};
    theta = varargin{2};
    quad = varargin{3};
    % Fixed values
    window_size = 31;
    NLevels = 16;
    D = 1;
    % Pick up the size of the images
    [N,M] = size(mosaic)
% Quantization of the image pixels into 16 Gray-levels
    for i=1:M
        for j=1:N
            if round(mosaic(i,j)/16) == 0
                mosaic(i,j) = 1;
            else
                mosaic(i,j) = round(mosaic(i,j)/16);
            end
        end
    end
    
glcm_win = zeros(NLevels, NLevels);
glcm_win_norm = zeros(NLevels, NLevels);
feature = 0;

feature_img(M-window_size,N-window_size) = 0;
    

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
            glcm_win_sym = glcm_win + glcm_win'; % symmetric
            % Calculating the normalized GLCM matrix and unsing these
            % values to calculate the features of the matrix
            for k=1:NLevels
                for g=1:NLevels
                    glcm_win_norm(k,g) = glcm_win_sym(k,g)/(sum(sum(glcm_win_sym))); % normalized       
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

                end
            end 
            end
            end
            end
        end
        
        % Calculate de feature value based on the GLCM's quadrant choosen
        
        %Verify if there is a sub-quadrant to be used to calculate the
        %feature, if so, call the "calculate_features" function passing the
        %sub-quadrant value
        if nargin == 4
            subquad = varargin{4};
            feature = calculate_features(glcm_win_norm,quad,subquad);
        else
            feature = calculate_features(glcm_win_norm,quad);
        end
        
        
        
        feature_img(i-((round(window_size/2))-1),j-((round(window_size/2))-1)) = feature;
        
        feature = 0;
        
        glcm_win = zeros(NLevels, NLevels);
        glcm_win_norm = zeros(NLevels, NLevels);
        
    end
end
 
    % Normalizing the GLCM feature matrix 
feature_img_min = min(min(feature_img));
feature_img_max = max(max(feature_img));
feature_img_norm (M-window_size,N-window_size) = 0;
for i=1:(M-window_size)
    for j=1:(N-window_size)
        feature_img_norm(i,j) = (feature_img(i,j)-feature_img_min)/(feature_img_max-feature_img_min);
    end
end
% Filling in the blank spaces caused by the window

feature_img_norm = padarray(feature_img_norm,[((round(window_size/2))) ((round(window_size/2)))],0,'both');

    imshow(feature_img_norm,[]);
end

