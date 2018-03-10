function Ifilt = nlm(I, searchWindowRadius, averageFilterRadius, sigma, nlm_sigma)
    
    % pad image to reduce boundary artifacts
    I = padarray(I,[averageFilterRadius averageFilterRadius],'symmetric');

    % initialize filtered image as 0
    Ifilt = zeros(size(I));
    
    % smoothing kernel
    kernel = fspecial('gaussian', [2*averageFilterRadius+1 2*averageFilterRadius+1], sigma);
        
    for ky= 1+averageFilterRadius:size(I,1)-averageFilterRadius
        for kx= 1+averageFilterRadius:size(I,2)-averageFilterRadius
            
            % extract current window
            currentWindow = I(  ky-averageFilterRadius:ky+averageFilterRadius, ...
                                kx-averageFilterRadius:kx+averageFilterRadius, :);
                            
            % accumulated normalization factor
            normalizationFactor = zeros([1 1 size(I,3)]);
            
            % go over a window of size 2*searchWindowRadius+1 around the
            % current pixel, compute weights based on difference of neighborhoods, 
            % sum the weighted intensity
            
            % hint: do !not! include the neighborhood centered at the
            % current pixel in this loop, it will throw off the weights
            
            
            for i = ky - searchWindowRadius : ky + searchWindowRadius
                for j = kx - searchWindowRadius : kx + searchWindowRadius
                    if i < 1 + averageFilterRadius || i > size(I, 1) - averageFilterRadius ...
                        || j < 1 + averageFilterRadius || j > size(I, 2) - averageFilterRadius
                        % out of bound
                        continue
                    end
                    if i == ky && j == kx
                        % current pixel
                        continue
                    end
                    
                    candi = I(i - averageFilterRadius : i + averageFilterRadius, ...
                                 j - averageFilterRadius : j + averageFilterRadius, ...
                                 :) ;
                    weight = exp(-sum(sum(kernel .* (candi - currentWindow).^2, 1), 2) / nlm_sigma^2);
                    normalizationFactor = normalizationFactor + weight;
                    Ifilt(ky,kx,:) = Ifilt(ky,kx,:) + weight * I(i, j, :);
                end
            end
            
        
        
            
%            % this one makes it a bit better - add current pixel as well with max weight computed from all other neighborhoods           
%            normalizationFactor = normalizationFactor + weight_max;
%            Ifilt(ky,kx,:) = Ifilt(ky,kx,:) + weight_max .* I(ky,kx,:);   

            % normalize pixel value
            Ifilt(ky,kx,:) = Ifilt(ky,kx,:) ./ normalizationFactor;

        end
    end
    
    % crop black boundary
    Ifilt = Ifilt(averageFilterRadius+1:end-averageFilterRadius, averageFilterRadius+1:end-averageFilterRadius,:);
end
