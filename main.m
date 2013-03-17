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

    addpath(genpath('./'))              % add subdirectories to path

    DATA_DIR = 'images/color/';
    %DATA_DIR = 'images/gray/';
    OUTPUT_DIR = 'output/';
    
    [~, fn, ~] = fileparts(filename);

    %profile on  % profile your code
    
    % open image
    A = imread(strcat(DATA_DIR, filename));
    
    
    % process image
    display('preprocessing')
    A_rgb = double(A);                  % convert uint8 to double
    A_yuv = rgb2yuv(A_rgb);             % RGB to YUV transformation   
    [Y, U, V] = subsampling420(A_yuv);  % chroma subsampling 4:2:0
    
    display('wavelet encoding')
    wavelet = 0;                        % choose b/w Haar and Daubechies
    Y_wv = DWTEncoder(Y, wavelet);
    U_wv = DWTEncoder(U, wavelet);
    V_wv = DWTEncoder(V, wavelet);
        
    % bit plane coding (potentially zero-tree pimped)
    display('bit plane encoding')
    numIter = ceil(log2(max(abs(Y_wv(:))))) +3;
    tic,
    Bs = BitplaneEncoding(Y_wv, U_wv, V_wv, numIter);
    %Bs = BitplaneZerotreeEncoding(Y_wv, U_wv, V_wv, numIter);
    toc
    %pause                              % pause for bitstream manipulation
    display('bit plane decoding')
    tic,
    [Y_bp, U_bp, V_bp] = BitplaneDecoding(Bs);
    %[Y_bp, U_bp, V_bp] = BitplaneZerotreeDecoding(Bs);
    toc
    
    display('wavelet decoding')
    Y_dwt = DWTDecoder(Y_bp, wavelet);
    U_dwt = DWTDecoder(U_bp, wavelet);
    V_dwt = DWTDecoder(V_bp, wavelet);

    display('postprocessing')
    A_up = upsampling420(Y_dwt, U_dwt, V_dwt); % chroma upsampling 4:2:0
    A_res = yuv2rgb(A_up);               % convert YUV to RGB color space
    
    
    % make some plots and save them to disc
    display('make plots')
    plot_yuv(A_rgb, A_yuv);
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_yuv'), 'png')
    
    plot_sub(A_yuv, Y, U, V);
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_sub'), 'png')

    plot_wavelets(Y, wavelet);
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_wavelets'), 'png')

    plot_wavelets2(Y);
    saveas(gcf, strcat(OUTPUT_DIR, fn, '_wavelet_comp'), 'png')
    
    %display('show some analysis')
    %plot_DR(A_yuv)
    %saveas(gcf, strcat(OUTPUT_DIR, fn, '_dr'), 'png')
    
    %plot_mE(A_yuv(:,:,1))
    %saveas(gcf, strcat(OUTPUT_DIR, fn, '_me'), 'png')
    
    figure,
    subplot(1,2,1), imshow(uint8(A_rgb)), title('The original'),
    subplot(1,2,2), imshow(uint8(A_res)), title('The End')
        
    %stats = profile('info');
    %profile off

end