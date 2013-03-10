function main(fname)
%MAIN       Calls all code with a provided filename if any.

    % set default filename
    if (nargin < 1)
        %filename = 'baboon.tiff';
        %filename = 'clock.tiff';
        filename = 'fault.jpg';
    else
        filename = fname;
    end

    addpath('01_farbraeume');
    addpath('03_bitplanes');

    DATA_DIR = 'images/color/';
    %DATA_DIR = 'images/gray/';
    OUTPUT_DIR = 'output/';
    
    [~, fn, ~] = fileparts(filename);

    %profile on  % profile your code
    
    % open image
    A = imread(strcat(DATA_DIR, filename));
    
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
    %cut = [128,64,32,16,8,4,1];
    cut = [1];
    peak = zeros(size(cut));
    for c = 1:numel(cut)
        tic, Bs = bitplaneEncoding(A_y, cut(c)); toc
        tic, A_bp = bitplaneDecoding(Bs, threshold, m, n); toc
        peak(c) = psnr(A_yuv(:,:,1), A_bp, threshold);
    end
    
    % wavelet transformation
    %teuxdeux

    
    % make some plots and save them to disc
    %plot_yuv(A_yuv);        % plot each YUV channel separately
    %saveas(gcf, strcat(OUTPUT_DIR, fn, '_yuv'), 'png')
    %
    %plot_sub(A_yuv, A_sub, A_up)
    %saveas(gcf, strcat(OUTPUT_DIR, fn, '_sub'), 'png')
    %
    %plot_bitplanes(A, A_bp)
    %saveas(gcf, strcat(OUTPUT_DIR, fn, '_bitplanes'), 'png')
    %plot_psnr(peak, threshold, cut)
    %saveas(gcf, strcat(OUTPUT_DIR, fn, '_psnr'), 'png')
    %
    plot_day5(A, A_yuv, A_bp, A_sub),
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_day5'), 'png')
        
    %stats = profile('info');
    %profile off

end