function output_image = stack_tiles(processed_tile_cell, overlapping_size)
    tileSize = 16;
    [cell_row, cell_col] = size(processed_tile_cell);
    m = (tileSize-overlapping_size)*(cell_row - 1) + tileSize;
    n = (tileSize-overlapping_size)*(cell_col - 1) + tileSize;
    output_image = zeros(m, n);
    avg_index = zeros(m, n);
    all_ones = ones(tileSize, tileSize);
    
    for i = 1:cell_row
        for j = 1:cell_col
            index_i = (i-1)*(tileSize-overlapping_size) + 1;
            index_j = (j-1)*(tileSize-overlapping_size) + 1;
            output_img(index_i:index_i+tileSize, index_j:index_j+tileSize) = ...
                output_img(index_i:index_i+tileSize, index_j:index_j+tileSize) + processed_tile_cell{i, j};
            avg_index(index_i:index_i+tileSize, index_j:index_j+tileSize) = ...
                avg_index(index_i:index_i+tileSize, index_j:index_j+tileSize) + all_ones;
        end
    end
    
    output_image = output_image./avg_index;
end
