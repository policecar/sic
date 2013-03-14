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
    addpath('plots');

    DATA_DIR = 'images/color/';
    %DATA_DIR = 'images/gray/';
    OUTPUT_DIR = 'output/';
    
    [~, fn, ~] = fileparts(filename);

    %profile on  % profile your code
    
    % open image
    A = imread(strcat(DATA_DIR, filename));
    
    % process image
    % preprocessing
    display('preprocessing')
    A_rgb = double(A);                  % convert uint8 to double
    A_yuv = rgb2yuv(A_rgb);             % RGB to YUV transformation   
    [Y, U, V] = subsampling420(A_yuv);  % chroma subsampling 4:2:0
    
    % discrete wavelet tranformation
    display('wavelet transformation')
    wavelet = 1;                        % choose b/w Haar and Daubechies
    Y_wv = DWTEncoder(Y, wavelet);
    Y_dwt = DWTDecoder(Y_wv, wavelet);
    U_wv = DWTEncoder(U, wavelet);
    U_dwt = DWTDecoder(U_wv, wavelet);
    V_wv = DWTEncoder(V, wavelet);
    V_dwt = DWTDecoder(V_wv, wavelet);
    
    % temporary hack until bit plane coding works w/ diff. sizes
    A_wv = upsampling420(Y_wv,U_wv,V_wv);
    A_dwt = upsampling420(Y_dwt, U_dwt, V_dwt);
    
    % bit plane coding (potentially zero-tree pimped)
    display('bit plane coding')
    numIter = 7;
    tic,
    Bs = BitplaneEncoding(A_dwt(:,:,1),A_dwt(:,:,2),A_dwt(:,:,3),numIter);
    %Bs = BitplaneZerotreeEncoding(A_dwt(:,:,1), A_dwt(:,:,2), ...
    %    A_dwt(:,:,3),numIter);
    toc
    pause                               % pause for bitstream manipulation
    tic, A_bp = BitplaneDecoding(Bs); toc
    %tic, A_bp = BitplaneZerotreeDecoding(Bs); toc
    
    % postprocessing
    display('postprocessing')
    Y = A_bp(:,:,1);
    A_up = upsampling420(Y, U, V);      % chroma upsample 4:2:0
    A_res = yuv2rgb(A_up);              % convert YUV to RGB color space
    
    
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
    plot_day6(A_yuv, A_wv, A_dwt),
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_day6'), 'png')
    %
    plot_final(A_rgb, A_res);
%     saveas(gcf, strcat(OUTPUT_DIR, fn, '_day9'), 'png')
    
        
    %stats = profile('info');
    %profile off

end