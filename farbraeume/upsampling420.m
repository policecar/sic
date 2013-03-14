function B = upsampling420(Y, U, V)
%UPSAMPLING_420     Combines three given channels to an image in 4:2:0 
%                   ratio by upsampling the color channels.
    
    [m, n] = size(Y);
    B = zeros(m,n,3);
    
    % upsample by a factor of 2
    lil = ones(2,2);
    B(:,:,2) = kron(U, lil);
    B(:,:,3) = kron(V, lil);
    
    B(:,:,1) = Y;   % keep original Y (luminance channel)
    
end