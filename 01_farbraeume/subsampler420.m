function [B, up] = subsampler420(A)
%CHROMA_SUBSAMPLER_420  Encodes an image given in YUV color space 
%                       in 4:2:0 chroma subsampling.

    B = zeros(size(A));
    sub = A(1:2:end,1:2:end,:); % subsample A by a factor of 2
    
    lil = ones(2,2);            % upsample sub by a factor of 2
    up = zeros(size(sub) .* [2,2,1]);
    for i = 1:size(A,3)
        up(:,:,i) = kron(sub(:,:,i),lil);
    end
    
    B(:,:,1) = A(:,:,1);        % keep original Y (luminance channel)
    B(:,:,2:3) = up(:,:,2:3);   % use subsampled U, V (chroma channels)

end