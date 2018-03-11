function Ifilt = bilateral(I, averageFilterRadius, sigmaSpatial, sigmaIntensity)

    % pad image to reduce boundary artifacts
    I = padarray(I,[averageFilterRadius averageFilterRadius],'symmetric');
    %fprintf('size(A) is %s\n', mat2str(size(I)));

    % initialize filtered image as 0
    Ifilt = zeros(size(I));
    
    % smoothing kernel - you can use that as a look-up table for the
    % spatial kernel if you like
    spatialKernel = fspecial('gaussian', [2*averageFilterRadius+1 2*averageFilterRadius+1], sigmaSpatial);
        
    for ky= 1+averageFilterRadius:size(I,1)-averageFilterRadius
        for kx= 1+averageFilterRadius:size(I,2)-averageFilterRadius
            % extract current pixel
            %I just have 2 dimensions
            currentPixel = I(ky,kx,:);
            
            
                            
            % accumulated normalization factor
            normalizationFactor = zeros([1 1 size(I,3)]);
            
            % go over a window of size 2*averageFilterRadius+1 around the
            % current pixel, compute weights, sum the weighted intensity

            xmin = kx - averageFilterRadius;
            xmax = kx + averageFilterRadius;
            ymin = ky - averageFilterRadius;
            ymax = ky + averageFilterRadius;

            iDiff = I(ymin:ymax, xmin:xmax) - currentPixel;
            iDiff = exp(-iDiff.^2/(2*sigmaIntensity^2));
            
            weight = spatialKernel.*iDiff;
            
            Ifilt(ky, kx) = sum(sum(weight.*I(ymin:ymax, xmin:xmax)));
            normalizationFactor = sum(sum(weight));
            
            % normalize pixel value
            Ifilt(ky,kx,:) = Ifilt(ky,kx,:) ./ normalizationFactor;

        end
    end
    
    % crop black boundary
    Ifilt = Ifilt(averageFilterRadius+1:end-averageFilterRadius, averageFilterRadius+1:end-averageFilterRadius,:);
end

