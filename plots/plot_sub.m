
function plot_sub(YUV, A_up)
%PLOT_SUB       Plots an image and its 4:2:0 and 2:4:0 chroma subsampled 
%               versions.

    figure,
    
    RGB = yuv2rgb(YUV);
    subplot(1,3,1), imshow(uint8(RGB));
    title('Original image'),

    A_up = yuv2rgb(A_up);
    subplot(1,3,2), imshow(uint8(A_up));
    title('4:2:0 chroma subsampling')

    Y = YUV(1:2:end,1:2:end,1); % subsample
    Y = kron(Y, ones(2,2));     % upsample
    YUV(:,:,1) = Y;             % merge
    A_rgb = yuv2rgb(YUV);       % color transform
    subplot(1,3,3), imshow(uint8(A_rgb));
    title('2:4:0 chroma subsampling')

end