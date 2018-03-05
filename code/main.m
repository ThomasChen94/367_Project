%%
clc;clear;
image_path_list = dir('../dataset/*.pgm');
num_img = length(image_path_list);
img_list = cell(1, num_img);
 
for i=1:num_img
    img_list{i} = im2double(imread(strcat('../dataset/', image_path_list(i).name)));
end 

%%
TILE_SIZE = 16;
OVERLAPPING_SIZE = 0;
tiles_list = cell(1, num_img);
for i = 1 : num_img
    I = img_list{i};
    tiles_list{i} = split_tiles(I, TILE_SIZE, OVERLAPPING_SIZE); 
end

%%
method_idx = 1; % method index: 0: baseline | 1: hdr | 2: our method
if method_idx == 0
    merged_cell = merge_average(tiles_list);
elseif method_idx == 1
    merged_cell = merge_hdrplus(tiles_list);
elseif method_idx == 2
    % TODO: implement our own method
    merged_cell = merge_average(tiles_list);
end
%%
output_image = stack_tiles(merged_cell, TILE_SIZE, OVERLAPPING_SIZE);
%%
imshow(output_image); title('raw image after merging');
imwrite(output_image, '../output/merge_output.pgm');
%%
%demosaic
testBayerPattern;



