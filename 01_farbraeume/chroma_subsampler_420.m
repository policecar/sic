function B = chroma_subsampler_420(A)

    B = zeros(size(A));
    sub = subsample(A);
    up = upsample(sub);
    
    B(:,:,1) = A(:,:,1);        % keep original Y (luminance channel)
    B(:,:,2:3) = up(:,:,2:3);   % use sub/upsampled U, V (chroma channels)

end