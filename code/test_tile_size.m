tile_size_list = [2, 16, 64, 1024];
overlapping_size_list = [0.5];
for tile_size = tile_size_list
    for overlapping_size = overlapping_size_list
        
        disp(['Now we are on: ', num2str(tile_size), ' ', 'overlapping_size'])
        
        disp('Splitting images to tiles...')
        TILE_SIZE = tile_size;
        OVERLAPPING_SIZE = TILE_SIZE * overlapping_size;
        
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


        method_idx = 1; % method index: 0: baseline | 1: hdr | 2: our method
        disp('Merging different frames...')
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



        %demosaic
        %testBayerPattern;

        %alternative matlab demosaic
        I = output_image;
        I = I(1:size(img_list{1}, 1), 1:size(img_list{1}, 2));
        I = I - min(min(I)); % black-level subtraction


        disp('White balancing...')
        I_whiteBalane = whiteBalance(I);

        disp('demosaicing...')
        J_demosaic = our_demosaic(I_whiteBalane,'/chen/4rggb.png');

        %fprintf('chroma denoise...\n');
        %J_chroma = chroma_denoise(J_demosaic, '/chen/4chroma.png');
        output = J_demosaic * 4;
        imwrite(output, ['../output/tile_size_test/', num2str(TILE_SIZE), '_', num2str(OVERLAPPING_SIZE), '.png'])
    end
end