
function plot_yuv(RGB, YUV)
% PLOT_YUV      Separately transforms the channels of a YUV image to RGB
%               and plots them.
    
    figure,
    
    % plot all channels
    subplot(1,4,1), imshow(uint8(RGB));
    title('Original image'),
    
    % plot each channel separately, filling missing dimensions with 0s
    chan = ['Y','U','V'];
    for i = 1:size(YUV,3)
        
        A = zeros(size(YUV));
        A(:,:,i) = YUV(:,:,i);
        A = yuv2rgb(A);
        subplot(1,4,i+1), imshow(uint8(A));
        title(strcat(chan(i),' channel')),
        
    end
end