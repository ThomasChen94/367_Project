function output = tonemap_pro(I, filename)

% global tone mapping
I = imread('../dataset/1.tiff');

I = im2double(I);

% I = 10 * I;

hdr1 = imadjust(I,[0,1],[0,1],1.0/8);
imwrite(hdr1, './test/hdr_1.png');

Iintensity = (20*I(:,:,1)+40*I(:,:,2)+I(:,:,3)) ./61; % There are many ways to compute the intensity, this is just an option
% chrominance channels 
Ichrominance = I ./ Iintensity;

% compute the log10 intensity: 
L = log10(Iintensity);

% Filter that with a bilateral filter: B = bf(L) xxx
% averageFilterRadius = 5; % Chnage if needed
% sigma               = % Complete
% sigmaIntensity      = % Complete
spatialSigma = 2;
intensitySigma = 0.5;

% % tong
% averageFilterRadius_Tong = 5; % Chnage if needed
% sigma_Tong              = 1.3;
% sigmaIntensity_Tong      = 0.4;
% 
% B = bilateral(L, averageFilterRadius_Tong, sigma_Tong, sigmaIntensity_Tong);
 
    
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
dR = 0.5;
s = dR / (max(max(B)) - min(min(B)));
BB = (B - max(max(B))) * s;
% Show the scaled base layer
figure;imagesc(BB); colorbar;title('Show BB'); colormap gray;

% Reconstruct the log intensity: 
O = 10.^(BB + D);

% convert back to RGB and apply gamma correction (2.2)
Itonemapped3 = O .* Ichrominance;

% Itonemapped3 = imadjust(Itonemapped3,[0,1], [0,1], 1/2.2);
imshow(Itonemapped3);

end
% imwrite(Itonemapped3, ['./wanzi/hdr2_spatial_' num2str(spatialSigma) '_inten_' num2str(intensitySigma) '_dR_' num2str(dR) '.png']);

