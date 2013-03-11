
function plot_sub( A_yuv, A_sub, A_up )
%PLOT_SUB   Plots an original image and its 4:2:0 chroma subsampled
%           version (and 2:4:0 version).

    figure,
    
    % convert orig A in YUV to RGB and plot it
    A_rgb = uint8(yuv2rgb(A_yuv));
    subplot(1,3,1), imshow(A_rgb);
    title('original image'),

    % show A w/ subsampled U and V
    A = uint8(yuv2rgb(A_sub));
    subplot(1,3,2), imshow(A);
    title('4:2:0 chroma subsampling')

    % show A w/ subsampled Y
    sY = A_yuv;
    sY(:,:,1) = A_up(:,:,1);
    sY = uint8(yuv2rgb(sY));
    subplot(1,3,3), imshow(sY);
    title('2:4:0 chroma subsampling')

end