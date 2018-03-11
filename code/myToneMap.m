%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   EE 367 / CS 448I Computational Imaging and Display
%   Stanford University
%   Instructor: Gordon Wetzstein (gordon.wetzstein@stanford.edu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; clf;

% load image
I = hdrread('hw4_memorial.hdr');

% normalize image
I = (I-min(I(:))) ./ (max(I(:))-min(I(:)));

subplot(2,2,1);
imshow(I.^(1/2.2));
title('Original HDR image');

imwrite(I, 'I_original.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a. gamma correct each color channel separately 

% set gamma
gamma = 1/6.5;

% tonemap intensity channel by applying gamma xxx
Itonemapped1 = imadjust(I,[0,1], [0,1], gamma);% Complete

subplot(2,2,2);
imshow(Itonemapped1);
title('Gamma-corrected intensity');
imwrite(Itonemapped1, 'I_gamma_color_separately.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% b. gamma correct only intensity channel, but do it on the full-color image

% compute intensity channel by averaging the three color channels
Iintensity = (20*I(:,:,1)+40*I(:,:,2)+I(:,:,3)) ./61; % There are many ways to compute the intensity, this is just an option

% chrominance channels 
Ichrominance = I ./ Iintensity;

% gamma correct intensity channel 
gammaB = 1/3.5;
O = imadjust(Iintensity,[0,1], [0,1], gammaB); % Complete

% convert back to RGB and apply gamma correction (2.2)
Itonemapped2 = imadjust(O.*Ichrominance, [0,1], [0,1], 1/2.2); % Complete

subplot(2,2,3);
imshow(Itonemapped2);
title('Gamma-corrected intensity in full-color');
imwrite(Itonemapped2, 'I_gamma_color_intensityonly.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% c. simplified version of Durand's bilateral filter

% compute the log10 intensity: 
L = log10(Iintensity);

% Filter that with a bilateral filter: B = bf(L) xxx
% averageFilterRadius = 5; % Chnage if needed
% sigma               = % Complete
% sigmaIntensity      = % Complete
spatialSigma = 1;
intensitySigma = 0.01;
B = biFilter(spatialSigma, intensitySigma, L);
% Show B
figure;imagesc(B); colorbar;title('Show B'); colormap gray;
% Compute the detail layer: 
D = L - B;% Complete
% Show D
figure;imagesc(D); colorbar;title('Show D'); colormap gray;

% Apply an offset and a scale to the base 
% The offset is such that the maximum intensity of the base is 1. Since the values are in the log domain, o = max(B).
% The scale is set so that the output base has dR stops of dynamic range, i.e., s = dR / (max(B) - min(B)).
dR = 1.5;
s = dR / (max(max(B)) - min(min(B)));
BB = (B - max(max(B))) * s;
% Show the scaled base layer
figure;imagesc(BB); colorbar;title('Show BB'); colormap gray;

% Reconstruct the log intensity: 
O = 10.^(BB + D);

% convert back to RGB and apply gamma correction (2.2)
Itonemapped3 = O .* Ichrominance;
Itonemapped3 = imadjust(Itonemapped3,[0,1], [0,1], 1/2.2);

subplot(2,2,4);
imshow(Itonemapped3);
title('Simple bilateral-filtered image ');
imwrite(Itonemapped3, 'I_bilateral_color.png');
