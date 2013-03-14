
function plot_yuv(A_yuv)
% PLOT_YUV      Given a YUV image as 3-D matrix, separately transforms each 
%               channel to RGB color space and plots it.
    
    figure,
    A_rgb = uint8(yuv2rgb(A_yuv));
    subplot(1,4,1), imshow(A_rgb);      % plot all channels
    title('original image'),
    
    % plot each channel separately,
    % fill missing dimensions with 0s before transforming to RGB
    chan = ['Y','U','V'];
    for i = 1:size(A_yuv,3)
        A = zeros(size(A_yuv));
        A(:,:,i) = A_yuv(:,:,i);
        A = uint8(yuv2rgb(A));
        subplot(1,4,i+1), imshow(A);
        title(strcat(chan(i),' channel')),
    end
end