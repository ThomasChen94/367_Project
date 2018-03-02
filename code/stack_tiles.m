function output_image = stack_tiles(processed_tile_cell, tileSize, overlapping_size)
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
            
            output_image(index_i:index_i+tileSize - 1, index_j:index_j+tileSize - 1) = ...
                output_image(index_i:index_i+tileSize - 1, index_j:index_j+tileSize - 1) + processed_tile_cell{i, j};
            
            avg_index(index_i:index_i+tileSize - 1, index_j:index_j+tileSize - 1) = ...
                avg_index(index_i:index_i+tileSize - 1, index_j:index_j+tileSize - 1) + all_ones;
        end
    end
    
    output_image = output_image./avg_index;
end
