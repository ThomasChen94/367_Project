function [ output_cell ] = merge_hdrplus( all_tile_cell )
	% merge over tiles
	% all_tile_cell: a nested tile, length: number of bursts of photos
    % output_cell: a cell of a single photos
    
    num_photos = size(all_tile_cell, 2);  % [1, 10] take 10
    [len1, len2] = size(all_tile_cell{1});
    
    output_cell = cell([len1 len2]);
    
    c = 8; % hyperparameter, fixed as 8 in the paper
    for i = 1 : len1
        for j = 1 : len2
            % for each position, merge all tiles together
            ref = all_tile_cell{1}{i, j};
            T0 = fft2(ref);
            T0_tilde = T0;
            for z = 2 : num_photos
                % use the 1st photo as reference, start from the second one
                Pz = all_tile_cell{z}{i, j}; % the zth photo
                Tz = fft2(Pz);
                sigma = sqrt(sum(sum(Pz .* Pz)) / numel(Pz)); % evaluate the noise variance
           
                Dz = T0 - Tz;
             
                Az = abs(Dz).^2 ./ (abs(Dz).^2 + c * sigma);
%                 if min(Az(:)) < 10^(-8)
%                     disp('eeeek!');
%                 end
                T0_tilde = T0_tilde + Az .* (T0 - Tz) + Tz;
            end
            output_cell{i, j} = ifft2(T0_tilde / num_photos);
        end
    end
end

