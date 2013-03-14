
function plot_bitplanes(YUV, BP)
%PLOT_BITPLANES     Given and image and its bit plane codings, plot them.

    figure,
    title('Bit plane coding'),

    % helper variables
    k = 1;              % plot only the Y channel
    j = size(BP,2);     % number of bit planes
    l = ceil(j/2);
    BP(k,1,:,:) = YUV(:,:,1);
    
    for i = 1:j;
        subplot(2,l,i), imshow(uint8(squeeze(BP(k,j-i+1,:,:))));
    end

end