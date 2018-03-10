function [ I_whiteBalance ] = whiteBalance( I )
% the input I is a bayer raw matrix
% hard code
white_x = 943;
white_y = 2003;
        
%separate R G B channel
[m, n] = size(I);
red_mask = repmat([1 0;0 0], floor(m/2), floor(n/2));
green_mask = repmat([0 1;1 0], floor(m/2), floor(n/2));
blue_mask = repmat([0 0;0 1], floor(m/2), floor(n/2));
rawR = red_mask .* I;
rawG = green_mask .* I;
rawB = blue_mask .* I;

% in red
red = 0;
green = 0;
blue = 0;
if (mod(white_x, 2) == 1 && mod(white_y, 2) == 1)
    red = rawR(white_x, white_y);
    green1 = rawG(white_x + 1, white_y);
    green2 = rawG(white_x, white_y + 1);
    blue = rawB(white_x + 1, white_y + 1);
    green = max(green1, green2);
    if (red == 0 || green1 == 0 || green2 == 0 || blue == 0)
        fprintf('error in white balancing, zero value in current tile beginning with red\n');
    end
end

% white balance scale
ref = max(red, max(green, blue));
red_ratio = ref * 1.0 / red;
green_ratio = ref * 1.0 / green;
blue_ratio = ref * 1.0 / blue;
rawR = rawR * red_ratio;
rawG = rawG * green_ratio;
rawB = rawB * blue_ratio;

% global scale
maxVal = max(max(rawR(:)), max(max(rawG(:)), max(rawB(:))));
ratio = 0.99 / maxVal;
I_whiteBalance = rawR * ratio + rawG * ratio + rawB * ratio;
end
