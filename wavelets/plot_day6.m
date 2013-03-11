    
function plot_day6(A_yuv, A_haar, A_h)

    figure,
    
    subplot(1,3,1), imshow(uint8(yuv2rgb(A_yuv))),
    title('Original image')
    
    subplot(1,3,2), imshow(uint8(A_haar)),
    title('Haar encoded image')
    
    A_h(:,:,2:3) = A_yuv(:,:,2:3);
    subplot(1,3,3), imshow(uint8(yuv2rgb(A_h))),
    title('Haar transformed image')
    
end