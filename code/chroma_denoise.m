function [ resI ] = chroma_denoise( I, filename )


Ichroma = rgb2ycbcr(I);
Y = Ichroma(:,:,1);
Cb = Ichroma(:,:,2);
Cr = Ichroma(:,:,3);

spatialSigma = 2;
intensitySigma = 0.05;

% bilateral filter
resCb = biFilter(spatialSigma, intensitySigma, Cb);
resCr = biFilter(spatialSigma, intensitySigma,Cr);
resChroma = zeros(size(Ichroma));
resChroma(:,:,1) = Y;
resChroma(:,:,2) = resCb;
resChroma(:,:,3) = resCr;

resI  = ycbcr2rgb(resChroma);
imwrite(resI, ['../output/', filename]);

end
