    
function plot_day6(A_yuv, A_haar)

    figure,
    
    subplot(1,3,1), imshow(uint8(yuv2rgb(A_yuv))),
    title('Original image')
    
    A_haar(:,:,2:3) = A_yuv(:,:,2:3);
    subplot(1,3,2), imshow(uint8(yuv2rgb(A_haar))),
    title('Wavelet transformed image')
    
    A_diff = A_haar(:,:,1) - A_yuv(:,:,1);
    subplot(1,3,3), imshow(uint8(A_diff)),
    title('the difference'), colorbar

end