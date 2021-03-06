function [ resI ] = biFilter(spatialSigma, intensitySigma, rawI)
% spatialSigma: the sigma used in spatial Gaussian,
%   this is also the radius of the entire bilateralFilter
% intensity sigma: the sigma used in intensity Gaussian
% rawI: the original image matrix(2D)
% resI: the filtered image matrix(2D)

% padding symmetrically to reduce skew on edges
padI = padarray(rawI, [spatialSigma, spatialSigma],'symmetric');
% spatial kernel
hsize = 2*spatialSigma + 1;  % size of the entire filter, we keep it aligned with the spatial sigma
spatialKernel = fspecial('gaussian', hsize, spatialSigma);
% intensity
resI = zeros(size(padI));
% go over a window of size (2*spatial+1) around the center pixel
for x = (1 + spatialSigma) : (size(padI, 1) - spatialSigma)
    for y = (1 + spatialSigma) : (size(padI, 2) - spatialSigma)
%         disp(['current pos: ', num2str(x), ' ', num2str(y)]);
        I0 = padI(x, y);
        rawIntensityKernel = padI((x-spatialSigma):(x+spatialSigma), (y-spatialSigma):(y+spatialSigma));
        intensityKernel = exp(-(rawIntensityKernel - I0).^2 / (2*intensitySigma^2));
        totalKernel = intensityKernel.*spatialKernel;
        totalWeight = sum(sum(totalKernel));
        resI(x,y) = sum(sum(totalKernel.*rawIntensityKernel))/ totalWeight;
    end
end
% unmirror
resI = resI((1+spatialSigma):(size(padI, 1)-spatialSigma), (1+spatialSigma):(size(padI,2)-spatialSigma));
