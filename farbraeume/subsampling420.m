function [B, up] = subsampling420(A)
%SUBSAMPLING_420    Chroma-subsamples an image given as 3-D matrix in YUV 
%                   color space at a ratio of 4:2:0.

    B = zeros(size(A));
    
    % subsample A by a factor of 2
    sub = A(1:2:end,1:2:end,:);
    
    % upsample sub by a factor of 2
    lil = ones(2,2);
    up = zeros(size(sub) .* [2,2,1]);
    for i = 1:size(A,3)
        up(:,:,i) = kron(sub(:,:,i),lil);
    end
    
    B(:,:,1) = A(:,:,1);        % keep original Y (luminance channel)
    B(:,:,2:3) = up(:,:,2:3);   % use subsampled U, V (chroma channels)

end