function output_image = stack_channel(output_image_R, output_image_B, output_image_G1, output_image_G2)
    % stack bayer pattern channel together
    output_image = zeros(size(output_image_R)*2);
    output_image(1 : 2 : end, 1 : 2 : end) = output_image_R;
    output_image(2 : 2 : end, 2 : 2 : end) = output_image_B;
    output_image(1 : 2 : end, 2 : 2 : end) = output_image_G1;
    output_image(2 : 2 : end, 1 : 2 : end) = output_image_G2;
end