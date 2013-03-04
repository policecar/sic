
function plot_420( YUV, A_420, ups )

    figure,
    
    % convert orig YUV to RGB and show
    RGB = uint8(yuv2rgb(YUV));
    subplot(1,3,1), imshow(RGB);

    % show A w/ subsampled U and V
    A_420 = uint8(yuv2rgb(A_420));
    subplot(1,3,2), imshow(A_420);

    % show A w/ subsampled Y
    sY = YUV;
    sY(:,:,1) = ups(:,:,1);
    sY = uint8(yuv2rgb(sY));
    subplot(1,3,3), imshow(sY);

end