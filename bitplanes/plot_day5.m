
function plot_day5(A, A_yuv, A_bp)

    figure,
    
    subplot(1,3,1), imshow(A),
    title('original image')

    Aa = A_bp;
    Aa = yuv2rgb(Aa);
    subplot(1,3,2), imshow(uint8(Aa)),
    title('bitplane coded image')
    
    A_diff = A_yuv - A_bp;
    subplot(1,3,3), imshow(uint8(yuv2rgb(A_diff))),
    title('diff b/w original and bitplane coding')

end