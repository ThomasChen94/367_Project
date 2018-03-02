function tile_image = split_tiles(I, tile_size, overlapping_size)
	% we only consider square tiles
	% padding with 0
    
    [h, w, c] = size(I);
    incre = tile_size - overlapping_size;
    tile_image_height = ceil((h - tile_size)/incre) + 1;
    tile_image_width = ceil((w - tile_size)/incre) + 1;
    
    pad_row_size = tile_image_height * incre + tile_size - h;
    pad_col_size = tile_image_width * incre + tile_size - w;
    
    I_pad = I;
    I_pad = [I_pad; ones(pad_row_size, size(I, 2))];
    I_pad = [I_pad, ones(size(I_pad, 1), pad_col_size)];
    
    tile_image = cell(tile_image_height, tile_image_width);
    
    for i = 1 : tile_image_height
        for j = 1 : tile_image_width
            i_I = 1 + (i-1) * incre;
            j_I = 1 + (j-1) * incre;
            tile_image{i, j} = I_pad(i_I:i_I+tile_size, j_I:j_I+tile_size);
        end
    end
    
    
    