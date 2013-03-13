    
function plot_day6(A_yuv, T, Y)

    figure,
    
    subplot(1,3,1), imshow(uint8(T)),
    title('Wavelet encoded image')
    
    subplot(1,3,2), imshow(uint8(Y)),
    title('Wavelet transformed image')
        
    A_diff = A_yuv(:,:,1) - Y;
    subplot(1,3,3), imagesc(A_diff),
    title('Diff b/w Y and original')
    
end