%%
clc;clear;
image_path_list = dir('../dataset/*.tiff');
num_img = length(image_path_list);
img_list = cell(1, num_img);
 
for i=1:num_img
    img_list{i} = im2double(imread(strcat('../dataset/', image_path_list(i).name))) * 64;
end 

% scale_factor = (2^2).^[6,6,1,5,6,2,3,4,5,6];
% %scale_factor = 2.^[6,6,6,6,6,6,6,6,6,6];
% 
% for i=1:num_img
%     img_list{i} = im2double(imread(strcat('../dataset/', image_path_list(i).name))) * scale_factor(i);
% end

%%
TILE_SIZE = 32;

OVERLAPPING_SIZE = 4;
tiles_list = cell(1, num_img);
tiles_list_R = cell(1, num_img);
tiles_list_B = cell(1, num_img);
tiles_list_G1 = cell(1, num_img);
tiles_list_G2 = cell(1, num_img);

for i = 1 : num_img
    I = img_list{i};
    [I_R, I_B, I_G1, I_G2] = split_channel(I);
    tiles_list_R{i}   = split_tiles(I_R, TILE_SIZE, OVERLAPPING_SIZE); 
    tiles_list_B{i} = split_tiles(I_B, TILE_SIZE, OVERLAPPING_SIZE);
    tiles_list_G1{i} = split_tiles(I_G1, TILE_SIZE, OVERLAPPING_SIZE);
    tiles_list_G2{i} = split_tiles(I_G2, TILE_SIZE, OVERLAPPING_SIZE);
    tiles_list{i} = split_tiles(I, TILE_SIZE, OVERLAPPING_SIZE);
end

%%
method_idx = 1; % method index: 0: baseline | 1: hdr | 2: our method
if method_idx == 0
    merged_cell = merge_average(tiles_list);
    output_image = stack_tiles(merged_cell, TILE_SIZE, OVERLAPPING_SIZE);
elseif method_idx == 1
    merged_cell_R  = merge_hdrplus(tiles_list_R);
    merged_cell_B  = merge_hdrplus(tiles_list_B);
    merged_cell_G1 = merge_hdrplus(tiles_list_G1);
    merged_cell_G2 = merge_hdrplus(tiles_list_G2);
    
    output_image_R = stack_tiles(merged_cell_R, TILE_SIZE, OVERLAPPING_SIZE);
    output_image_B = stack_tiles(merged_cell_B, TILE_SIZE, OVERLAPPING_SIZE);
    output_image_G1 = stack_tiles(merged_cell_G1, TILE_SIZE, OVERLAPPING_SIZE);
    output_image_G2 = stack_tiles(merged_cell_G2, TILE_SIZE, OVERLAPPING_SIZE);

    output_image = stack_channel(output_image_R, output_image_B, output_image_G1, output_image_G2); % stack channel together
    
elseif method_idx == 2
    % TODO: implement our own method
    merged_cell = merge_average(tiles_list);
end


%%
imshow(output_image); title('raw image after merging');

imwrite(output_image, '../output/merge_output4.tiff');

%%
%alternative matlab demosaic
I = output_image;

fprintf('white balance...\n');
I_whiteBalane = whiteBalance(I);

fprintf('demosaic...\n');
J_demosaic = our_demosaic(I_whiteBalane,'/wanzi/4rggb.png');
fprintf('chroma denoise...\n');
J_chroma = chroma_denoise(J_demosaic, '/wanzi/4chroma.png');

% J = (J-min(J(:))) ./ (max(J(:))-min(J(:)));

fprintf('tonemapping...\n');
J_tonemap = tonemap_pro(J_chroma, '/wanzi/4hotel.png');

% imshow(J)


