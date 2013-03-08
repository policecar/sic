function main(fname)
%MAIN       Calls all code with a provided filename if any.

    % set default filename
    if (nargin < 1)
        filename = 'baboon.tiff';
        %filename = 'clock.tiff';
    else
        filename = fname;
    end

    addpath('01_farbraeume');
    addpath('03_bitplanes');

    DATA_DIR = 'images/color/';
    %DATA_DIR = 'images/gray/';
    OUTPUT_DIR = 'output/';
    
    fmt = 'tiff';
    [~, fn, ~] = fileparts(filename);

    %profile on  % profile your code
    
    % open image
    A = imread(strcat(DATA_DIR, filename), fmt);
 
    
    % process image
    A_rgb = double(A);      % convert uint8 to double
    
    % RGB to YUV transformation
    A_yuv = rgb2yuv(A_rgb);
    
    % chroma subsampling 4:2:0
    tic, [A_sub, A_up] = subsampling420(A_yuv); toc
    
    % bit plane coding
    A_y = A_yuv(:,:,1);     % process only the Y channel
    [m,n] = size(A_y);
    threshold = max(A_y(:));
    cut = [128,64,32,16,8,4,1];
    peak = zeros(size(cut));
    figure,
    subplot(2,4,1), imshow(A);
    title('original image'),
    for c = 1:numel(cut)
        tic, Bs = bitplaneEncoding(A_y, cut(c)); toc
        tic, A_bp = bitplaneDecoding(Bs, threshold, m, n); toc
        peak(c) = psnr(A_yuv(:,:,1), A_bp, threshold);
        numPlanes = ceil(log2(threshold) - log2(cut(c)));
        subplot(2,4,c+1), imshow(uint8(A_bp));
        title(strcat(num2str(numPlanes), ' planes')),
    end
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_bp_comp'), 'png')
    
    % wavelet transformation
    %teuxdeux

    
    % make some plots and save them to disc
    plot_yuv(A_yuv);        % plot each YUV channel separately
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_yuv'), 'png')

    plot_sub(A_yuv, A_sub, A_up)
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_sub'), 'png')
    
    plot_bitplanes(A, A_bp)
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_bitplanes'), 'png')
    plot_psnr(peak, threshold, cut)
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_psnr'), 'png')
    
    % save image
    % ...
    
    %stats = profile('info');
    %profile off

end