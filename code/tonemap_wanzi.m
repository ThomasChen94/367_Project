function output = tonemap_wanzi(I, I_scale, filename)

I = (I-min(I(:))) ./ (max(I(:))-min(I(:)));

% % global tone mapping
% I = imread('../dataset/1.tiff');
% 
% I = im2double(I);

% I = 10 * I;

% hdr1 = imadjust(I,[0,1],[0,1],1.0/8);
% imwrite(hdr1, './test/hdr_1.png');

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
intensitySigma = 0.01;

I_intensity_real = (20*I_scale(:,:,1)+40*I_scale(:,:,2)+I_scale(:,:,3)) ./61;
L_real = I_scale ./ I_intensity_real;
B_real = biFilter(spatialSigma, intensitySigma, L_real);
    
% B = biFilter(spatialSigma, intensitySigma, L);
% 
% % Show B
% figure;imagesc(B); colorbar;title('Show B'); colormap gray;
figure;imagesc(B_real); colorbar;title('Show B'); colormap gray;

D = L - B_real;% Complete

% Show D
figure;imagesc(D); colorbar;title('Show D'); colormap gray;

% Apply an offset and a scale to the base 
% The offset is such that the maximum intensity of the base is 1. Since the values are in the log domain, o = max(B).
% The scale is set so that the output base has dR stops of dynamic range, i.e., s = dR / (max(B) - min(B)).
dR = 0.3;
s = dR / (max(max(B_real)) - min(min(B_real)));
BB = (B_real - max(max(B_real))) * s;
% Show the scaled base layer
figure;imagesc(BB); colorbar;title('Show BB'); colormap gray;


% % Show D
% figure;imagesc(D); colorbar;title('Show D'); colormap gray;
% 
% % Apply an offset and a scale to the base 
% % The offset is such that the maximum intensity of the base is 1. Since the values are in the log domain, o = max(B).
% % The scale is set so that the output base has dR stops of dynamic range, i.e., s = dR / (max(B) - min(B)).
% dR = 0.3;
% s = dR / (max(max(B)) - min(min(B)));
% BB = (B - max(max(B))) * s;
% % Show the scaled base layer
% figure;imagesc(BB); colorbar;title('Show BB'); colormap gray;

% Reconstruct the log intensity: 
O = 10.^(BB + D);

% convert back to RGB and apply gamma correction (2.2)
Itonemapped3 = O .* Ichrominance;

output = Itonemapped3;
% Itonemapped3 = imadjust(Itonemapped3,[0,1], [0,1], 1/2.2);
imshow(Itonemapped3);

imwrite(Itonemapped3, ['../output/wanzi_tonemap_', filename]);

end
% imwrite(Itonemapped3, ['./wanzi/hdr2_spatial_' num2str(spatialSigma) '_inten_' num2str(intensitySigma) '_dR_' num2str(dR) '.png']);

