function output = denoisePoisson(I)
    % denoise the demosaiced image
    imageSize = [size(I,1) size(I,2)];

    % load PSF
    psf = fspecial('gaussian', [15 15], 1.5);

    % compute OTF
    otf = psf2otf(psf, imageSize);
    otft    = conj(otf);

    % define function handle for 2D convolution
    Afun    = @(x) ifft2( fft2(x).*otf, 'symmetric');
    m = imageSize(1);
    n = imageSize(2);

    % ADMM + TV Poisson deconvolution%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    maxIters = 100;
    rho = 0.1;
    lambda = 0.01;

    result_TV = zeros(m, n, 3);

    dy = [0 0 0; 0 -1 0; 0 1 0];
    dx = [0 0 0; 0 -1 1; 0 0 0];

    p2o = @(x) psf2otf(x, imageSize);

    dxFT    = p2o(dx);
    dxTFT   = conj(p2o(dx));
    dyFT    = p2o(dy);
    dyTFT   = conj(p2o(dy));

    for c = 1 : 3
        x = zeros(m, n);
        z = zeros(m, n, 4);
        u = zeros(m, n, 4);

        denominator = otft.*otf + 1 + dxTFT.*dxFT + dyTFT.*dyFT;

        for k = 1 : maxIters
            %x-update
            v = z - u;
            numerator = otft.*fft2(v(:,:,1)) + fft2(v(:,:,2)) + ...
                dxTFT.*fft2(v(:,:,3)) + dyTFT.*fft2(v(:,:,4));    
            x = real(ifft2(numerator./denominator));

            %z1_update
            v = Afun(x) + u(:,:,1);
            z1 = -(1-rho*v)/(2*rho) + sqrt(((1-rho*v)/(2*rho)).^2 + I(:,:,c)/rho);
            z(:,:,1) = z1;

            %z2_update
            v = x + u(:,:,2);
            z2 = zeros(m, n);
            z2(v >= 0) = v(v >= 0); 
            z2(v < 0) = 0;
            z(:,:,2) = z2;

            kappa = lambda/rho;

            %z3_update
            Dxx = real(ifft2(dxFT.*fft2(x)));
            v = Dxx + u(:,:,3);
            s = zeros(m, n);
            s(v>kappa) = v(v>kappa) - kappa;
            s(abs(v)<=kappa) = 0;
            s(v<-kappa) = v(v<-kappa) + kappa;
            z(:,:,3) = s;

            %z4-update
            Dxy = real(ifft2(dyFT.*fft2(x)));
            v = Dxy + u(:,:,4);
            s = zeros(m, n);
            s(v>kappa) = v(v>kappa) - kappa;
            s(abs(v)<=kappa) = 0;
            s(v<-kappa) = v(v<-kappa) + kappa;
            z(:,:,4) = s;

            %u-update
            u(:,:,1) = u(:,:,1) + Afun(x) - z(:,:,1);
            u(:,:,2) = u(:,:,2) + x - z(:,:,2);
            u(:,:,3) = u(:,:,3) + Dxx - z(:,:,3);
            u(:,:,4) = u(:,:,4) + Dxy - z(:,:,4);
        end
        result_TV(:,:,c) = x;
    end
    output = result_TV;
end