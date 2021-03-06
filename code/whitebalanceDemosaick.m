%get the fout type filters
f1 = [   0,   0,  -1,  0,   0;
         0,   0,   2,  0,   0;
        -1,   2,   4,  2,  -1;
         0,   0,   2,  0,   0;
         0,   0,  -1,  0,   0];

f2 = [   0,   0, 1/2,  0,   0;
         0,  -1,   0, -1,   0;
        -1,   4,   5,  4,  -1;
         0,  -1,   0, -1,   0;
         0,   0, 1/2,  0,   0];

f3 = [   0,   0,  -1,  0,   0;
         0,  -1,   4, -1,   0;
       1/2,   0,   5,  0, 1/2;
         0,  -1,   4, -1,   0;
         0,   0,  -1,  0,   0];
     
f4 = [   0,   0, -3/2,  0,   0;
         0,   2,   0,  2,   0;
      -3/2,   0,   6,  0,-3/2;
         0,   2,   0,  2,   0;
         0,   0, -3/2,  0,   0];
     

%normalize the filters
f1 = f1*0.125;
f2 = f2*0.125;
f3 = f3*0.125;
f4 = f4*0.125;


%separate R G B channel
%I = imread('../dataset2/1.tiff');

maxValue = 1023;
minValue = 0;

% normalize I to img
% img = (double(I) - minValue) * 1.0 / maxValue;
img = double(I);

[m, n] = size(img);
red_mask = repmat([1 0;0 0], floor(m/2), floor(n/2));
green_mask = repmat([0 1;1 0], floor(m/2), floor(n/2));
green_mask_1 = repmat([0 1;0 0], floor(m/2), floor(n/2));
green_mask_2 = repmat([0 0;1 0], floor(m/2), floor(n/2));
blue_mask = repmat([0 0;0 1], floor(m/2), floor(n/2));
red_raw = red_mask.*img;

green_raw = green_mask.*img;
blue_raw = blue_mask.*img;
filtered1 = imfilter(img, f1);
filtered2 = imfilter(img, f2);
filtered3 = imfilter(img, f3);
filtered4 = imfilter(img, f4);

%get green channel
GatR = red_mask.*filtered1;
GatB = blue_mask.*filtered1;
green_highqual = green_raw + GatR + GatB;

%get red channel
RatGinR = green_mask_1.*filtered2;
RatGinG = green_mask_2.*filtered3;
RatBinB = blue_mask.*filtered4;
red_highqual = red_raw + RatGinR + RatGinG + RatBinB;

%get blue channel
BatGinB = green_mask_2.*filtered2;
BatGinR = green_mask_1.*filtered3;
BatRinR = red_mask.*filtered4;
blue_highqual = blue_raw + BatGinB + BatGinR + BatRinR;

%chop theborders
red_highqual = red_highqual(2:m-1, 2:n-1);
green_highqual = green_highqual(2:m-1, 2:n-1);
blue_highqual = blue_highqual(2:m-1, 2:n-1);

% white balance
% make means of all color channels the same
meanR = mean2(red_highqual);
meanG = mean2(green_highqual);
meanB = mean2(blue_highqual);

maxMean = max(meanR, max(meanG, meanB));

red_highqual = double(red_highqual) * maxMean / meanR;
green_highqual = double(green_highqual) * maxMean / meanG;
blue_highqual = double(blue_highqual) * maxMean / meanB;


img_highqual = cat(3, red_highqual, green_highqual, blue_highqual);

% restored_highqual = imadjust(img_highqual,[0,1],[0,1],1.0/2.2);
% imwrite(restored_highqual, '../output/hdr_input.png');

% img_res = img_highqual * maxValue + minValue;
img_res = img_highqual;
img_res = uint16(img_res);

imwrite(img_res, './wanzi/whiteBalance_2.tiff');
