function [I_R, I_B, I_G1, I_G2] = split_channel(I)
    % split bayer pattern into 4 channels
    % bayer pattern arrangement: R G G B
    I_R = I(1 : 2 : end, 1 : 2 : end);
    I_B = I(2 : 2 : end, 2 : 2 : end);
    I_G1 = I(1 : 2 : end, 2 : 2 : end);
    I_G2 = I(2 : 2 : end, 1 : 2 : end);
end