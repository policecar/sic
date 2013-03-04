
function plot_420( YUV, ups )

    figure,
    %subplot(1,3,1), imshow(uint8(orig));  % show YUV ;)
    
    oRGB = uint8(yuv2rgb(YUV));            % convert orig to RGB
    subplot(1,3,1), imshow(oRGB);          % and show

    sUV = YUV;                             % show w/ subsampled U and V
    sUV(:,:,2) = ups(:,:,2);
    sUV(:,:,3) = ups(:,:,3);
    sUV = uint8(yuv2rgb(sUV));
    subplot(1,3,2), imshow(sUV);

    sY = YUV;                              % show w/ subsampled Y
    sY(:,:,1) = ups(:,:,1);
    sY = uint8(yuv2rgb(sY));
    subplot(1,3,3), imshow(sY);

end