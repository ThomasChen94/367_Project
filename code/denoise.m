function output = denoise(I, method)
    % denoise the demosaiced image
    % I: noisy image to be denoised
    % method: method for denoising: 1: bilateral filter
    %                               2: NLM
   
    sigmaSpatial = [0.5, 1, 2];
    numFilters   = numel(sigmaSpatial);
    output_list = cell(numFilters, 1);
    for k=1:numFilters
        output_temp = zeros(size(I)); % placeholder of output image
        if method == 1
            % bilateral denoise
            sigma       = sigmaSpatial(k);
            filterSize  = 2*sigma+1;
            averageFilterRadius     = floor(filterSize/2);
            sigmaIntensity          = 0.15;
            for c=1:size(I,3)
                output_temp(:,:,c) = bilateral(I(:,:,c), averageFilterRadius, sigma, sigmaIntensity);
            end
            
        elseif method == 2
            % non-local means denoising
            averageFilterRadius     = floor(filterSize/2) + 1;
            nlm_sigma               = 0.07;
            searchWindowRadius      = 5;           
            for c=1:size(I,3)
                output_temp(:,:,c) = nlm(I(:,:,c), searchWindowRadius, averageFilterRadius, sigma, nlm_sigma);
            end
        end
        figure;
        imshow(output_temp);
        output_list{k} = output_temp;
    end
    output = output_list{1};
end