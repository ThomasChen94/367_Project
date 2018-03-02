function [ output_cell ] = merge( all_tile_cell )
	% merge over tiles
	% all_tile_cell: a nested tile, length: number of bursts of photos
    % output_cell: a cell of a single photos
    
    num_photos = size(all_tile_cell, 1);  % [10] take 10
    [len1, len2] = size(all_tile_cell{1});
    matrix_size = size(all_tile_cell{1}{1,1});
    
    output_cell = cell(1,num_photos);
    for p = 1:numphotos
        output_cell{p} = cell([len1, len2]);
    end
    
    for i = 1:len1
        for j = 1:len2
            T0 = zeros(matrix_size);
            for p = 1:num_photos
                T0 = T0 + fft2(all_tile_cell{p}{i}{j});
            end
            T0 = T0 * 1.0 / num_photos;
            output_cell{p}{i}{j} = real(ifft2(T0));
        end
    end
end

