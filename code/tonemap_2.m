
Iintensity = (20*J_chroma(:,:,1)+40*J_chroma(:,:,2)+J_chroma(:,:,3)) ./61; 

% chrominance channels 
Ichrominance = J_chroma./repmat(Iintensity,[1,1,3]);

Iintensity = Iintensity .^ (1/3.1);
imshow(1.4 * Iintensity .* Ichrominance);