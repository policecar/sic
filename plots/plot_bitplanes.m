
function plot_bitplanes(BP)
%PLOT_BITPLANES     Plot bit plane coded channels Y, U, V as well as the
%                   the bit planes at different thresholds.

    figure,
    title('Bit plane coding'),
    
    % helper variables
    j = length(BP);
    l = ceil(j/2);
    sz = length(BP{1,1});
    A = zeros(sz, sz, 3, j);
    
    for i = 1:j,
       
        A(:,:,:,i) = upsampling420(BP{1,i}, BP{2,i}, BP{3,i});
        subplot(2,l,i), imshow(uint8(yuv2rgb(A(:,:,:,i)))),
        
    end
    
end