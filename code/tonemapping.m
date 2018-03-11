function output = tonemapping(I, filename)
    %input I has 3 channels and value between [0, 1]
    %parameters that might need adjust:averageFilterRadius, sigma,
    %sigmaIntensity, dR, gamma
    I = (I-min(I(:))) ./ (max(I(:))-min(I(:)));
    % compute intensity channel by averaging the three color channels
    Iintensity = (20*I(:,:,1)+40*I(:,:,2)+I(:,:,3)) ./61; 

    % chrominance channels 
    Ichrominance = I./repmat(Iintensity,[1,1,3]);

    % compute the log10 intensity: 
    L = log10(Iintensity);

    % Filter that with a bilateral filter: B = bf(L) 
    averageFilterRadius = 5; % Chnage if needed
    sigma               = 1.3;
    sigmaIntensity      = 0.4;
    
    B = bilateral(L, averageFilterRadius, sigma, sigmaIntensity);
    % Show B
    f = figure();imagesc(B); colorbar;colormap gray;
    saveas(f, 'Q2_Base.png');
    close(f);

    % Compute the detail layer:
    D = L-B;
    % Show D
    f = figure();imagesc(D); colorbar;colormap gray;
    saveas(f, 'Q2_Detail.png');
    close(f);

    % Apply an offset and a scale to the base 
    % The offset is such that the maximum intensity of the base is 1. Since the values are in the log domain, o = max(B).
    % The scale is set so that the output base has dR stops of dynamic range, i.e., s = dR / (max(B) - min(B)).

    dR = 1.6; %try different values, such as 1, 2
    s = dR / (max(B(:)) - min(B(:)));
    BB = (B-max(B(:))).*s;
    
    % Show the scaled base layer
    f = figure();imagesc(BB); colorbar;colormap gray;
    saveas(f, 'Q2_BaseScaled.png');
    close(f);

    % Reconstruct the log intensity: 
    O = 10.^(BB + D);

    % convert back to RGB and apply gamma correction
    gamma = 2.2;
    output = imadjust(Ichrominance.*repmat(O,[1,1,3]),[0,1],[0,1],1/gamma);
    
    imwrite(output, ['../output/tonemapping_', filename]);
end