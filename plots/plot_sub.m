
function plot_sub(A_yuv, Y, U, V)
%PLOT_SUB       Plots an image and its 4:2:0 and 2:4:0 chroma subsampled 
%               versions.

    figure,
    
    subplot(1,3,1), imshow(uint8(yuv2rgb(A_yuv)));
    title('Original image'),

    A_up = upsampling420(Y, U, V);
    subplot(1,3,2), imshow(uint8(yuv2rgb(A_up)));
    title('4:2:0 chroma subsampling')

    Y = A_yuv(1:2:end,1:2:end,1);   % subsample
    Y = kron(Y, ones(2,2));         % upsample
    A_yuv(:,:,1) = Y;               % merge
    subplot(1,3,3), imshow(uint8(yuv2rgb(A_yuv)));
    title('2:4:0 chroma subsampling')

end