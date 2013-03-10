
function plot_day5(A, A_yuv, A_bp, A_sub)

    figure,
    
    subplot(1,3,1), imshow(A),
    title('original image')

    Aa = A_yuv; A(:,:,1) = A_bp;
    Aa = yuv2rgb(Aa);
    subplot(1,3,2), imshow(uint8(Aa)),
    title('bitplane coded Y channel')
    
    Aa = A_sub; Aa(:,:,1) = A_bp;
    Aa = yuv2rgb(Aa);
    subplot(1,3,3), imshow(uint8(Aa)),
    title('bitplane coded Y and chroma subsampled UV channels')

end