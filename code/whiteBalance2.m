function [ I_whiteBalance ] = whiteBalance2( I )
% the input I is a bayer raw matrix
%separate R G B channel
[m, n] = size(I);
red_mask = repmat([1 0;0 0], floor(m/2), floor(n/2));
green_mask = repmat([0 1;1 0], floor(m/2), floor(n/2));
blue_mask = repmat([0 0;0 1], floor(m/2), floor(n/2));
rawR = red_mask .* I;
rawG = green_mask .* I;
rawB = blue_mask .* I;
% white balance
% find meanR, G, B
posR = rawR > 0;
meanR = sum(rawR(:)) * 1.0 / sum(posR(:));
posG = rawG > 0;
meanG = sum(rawG(:)) * 1.0 / sum(posG(:));
posB = rawB > 0;
meanB = sum(rawB(:)) * 1.0 /sum(posB(:));
maxMean = max(meanR, max(meanG, meanB));

balanceR = double(rawR) * maxMean / meanR;
balanceG = double(rawG) * maxMean / meanG;
balanceB = double(rawB) * maxMean / meanB;
I_whiteBalance = balanceR + balanceG + balanceB;
end

