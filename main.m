function main(fname)
%MAIN       Calls all code with a provided filename if any.

    % set default filename
    if (nargin < 1)
        %filename = 'baboon.tiff';
        filename = 'lena.tiff';
        %filename = 'clock.tiff';
        %filename = 'fault.jpg';
    else
        filename = fname;
    end

    addpath('farbraeume');
    addpath('bitplanes');
    addpath('wavelets');

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
    
    % wavelet transformation
    %T_haar = DWTEncoder(A_yuv(:,:,1), 0);
    %Y_haar = DWTDecoder(T_haar, 0);    
    T_fbi = DWTEncoder(A_yuv(:,:,1), 1);
    Y_fbi = DWTDecoder(T_fbi, 1);

    % bit plane coding
    numIter = 7;
    tic,
    Bs = BitplaneEncoding(A_yuv(:,:,1), A_yuv(:,:,2), A_yuv(:,:,3), ...
        numIter);
    toc
    tic, A_bp = BitplaneDecoding(Bs); toc
    
    
    % analysis
    % eg. psnr for different numbers of iteration in bitplane coding
    % mittlere energiekonzentration

    
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
    %plot_day5(A, A_yuv, A_bp),
    %saveas(gcf, strcat(OUTPUT_DIR, fn, '_day5'), 'png')
    %
    plot_day6(A_yuv, T_fbi, Y_fbi),
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_day6'), 'png')  
        
    %stats = profile('info');
    %profile off

end