function [ I_whiteBalance ] = whiteBalance( I )
% the input I is a bayer raw matrix
% hard code
white_x = 943;
white_y = 2003;
ground_R = 0.7569;
ground_G = 0.7843;
ground_B = 0.8549;
        
scale_R = ground_R / I(white_x, white_y, 1);
scale_G = ground_G / I(white_x, white_y, 2);
scale_B = ground_B / I(white_x, white_y, 3);

I_whiteBalance = zeros(size(I));
I_whiteBalance(:, : ,1) = I(:, :, 1) * scale_R;
I_whiteBalance(:, : ,2) = I(:, :, 2) * scale_G;
I_whiteBalance(:, : ,3) = I(:, :, 3) * scale_B;

end
