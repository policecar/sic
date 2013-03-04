
function plot_yuv( A )
% PLOT_YUV      Separately transforms each YUV channel of a 3-dimensional
%               matrix to RGB color space and plots it.

    figure,
    A_all = uint8(yuv2rgb(A));
    subplot(1,4,1), imshow(A_all);      % show all channels
    
    for i = 1:size(A,3)
        A_one = zeros(size(A));         % fill missing dimensions with 0s
        A_one(:,:,i) = A(:,:,i);        % select a channel from A_yuv
        A_rgb = uint8(yuv2rgb(A_one));
        subplot(1,4,i+1), imshow(A_rgb);% plot each channel
    end
end