
function plot_wavelets(YUV, Y_enc, Y_dwt)
%PLOT_WAVELETS  Takes a Y channel, its wavelet encoded version (Haar or
%               Daubechies) and its wavelet transformation and plots them.

    figure,

    Y = YUV(:,:,1);
    subplot(1,4,1), imshow(uint8(Y)),
    title('original Y channel')

    subplot(1,4,2), imshow(uint8(Y_enc)),
    title('Wavelet encoding')
    
    subplot(1,4,3), imshow(uint8(Y_dwt)),
    title('Wavelet transformation')
        
    Diff = Y - Y_dwt;
    subplot(1,4,4), imshow(uint8(Diff)),
    title('Diff b/w Y and Y\_dwt')
    
end