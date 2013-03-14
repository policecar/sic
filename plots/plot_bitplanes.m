
function plot_bitplanes(BP)
%PLOT_BITPLANES     Given the bit planes of an images as 4-D matrix, plot
%                   them in succession.

    figure,
    title('Bit plane coding'),

    % helper variables
    k = 1;              % plot only the Y channel
    j = size(BP,2);     % number of bit planes
    
    for i = 1:j;
        subplot(2,j/2,i), imshow(uint8(squeeze(BP(k,j-i+1,:,:))));
    end

end