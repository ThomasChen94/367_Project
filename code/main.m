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
OVERLAPPING_SIZE = 2;
tiles_list = cell(1, num_img);
for i = 1 : num_img
    I = img_list{i};
    tiles_list{i} = split_tiles(I, TILE_SIZE, OVERLAPPING_SIZE); 
end

%%
merged_cell = merge(tiles_list);
%%
output_image = stack_tiles(merged_cell, TILE_SIZE, OVERLAPPING_SIZE);
%%
imshow(output_image); title('raw image after merging');
imwrite(output_image, 'result.png');




