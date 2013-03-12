    
function plot_day6(A_yuv, T, Y)

    figure,
    
    subplot(1,2,1), imshow(uint8(T)),
    title('Haar encoded image')
    
    A_diff = A_yuv(:,:,1) - Y;
    subplot(1,2,2), imagesc(A_diff),
    title('Diff b/w Y and original')
    
end