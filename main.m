function main(fname)
%MAIN       Calls a day's code with the filename provided in fname if any.

    % set default filename
    if (nargin < 1)
        %filename = 'baboon.tiff';
        filename = 'clock.tiff';
    else
        filename = fname;
    end

    addpath('01_farbraeume');
    addpath('03_bitplanes');

    OUTPUT_DIR = 'output/';
    fmt = 'tiff';

    %profile on  % profile your code
    
%     DATA_DIR = 'images/color/';
% 
%     % open image
%     A = imread(strcat(DATA_DIR, filename), fmt);
% 
%     % process image
%     A_rgb = double(A);                  % convert uint8 to double
%     A_yuv = rgb2yuv(A_rgb);             % transform RGB to YUV
%     [A_420, up] = subsampler420(A_yuv); % chroma subsampling 4:2:0
% 
%     % save image
%     imwrite(A_yuv, strcat(OUTPUT_DIR, 'yuv_', filename), fmt);


    %% day 3
    DATA_DIR = 'images/gray/';
    
    % load image
    A = imread(strcat(DATA_DIR, filename), fmt);
    
    % if image of color, convert to YUV first, process Y channel only
    A = A(:,:,1);
    
    % process image
    A = double(A);  % convert uint8 to double
    %A = [183 -4; -10.2, 11.5];
    cuts = [128,64,32,16,8,4,2,1];
    %cuts = [64];
    [m,n] = size(A);
    peak = zeros(size(cuts));
    A_bpd = zeros(size(A));
    for j = 1:numel(cuts)
        % encode matrix to bit plane encoding
        display('Bit plane encoding')
        tic
        Bs = bitplaneEncoder(A(:,:), cuts(j));
        toc
        % decode bit stream from bit plane decoding
        display('Bit plane decoding')
        tic
        threshold = max(max(A(:,:)));
        A_bpd(:,:) = bitplaneDecoder(Bs, threshold, m, n);
        toc
        % compute PSNR
        peak(j) = psnr(A, A_bpd, threshold);
    end
    
    % visualize transformed image
    plot_bitplane(A, A_bpd, peak, cuts, threshold)
    
    % save image
    imwrite(A_bpd, strcat(OUTPUT_DIR, 'bpd_', filename), fmt)
    
    %stats = profile('info');
    %profile off

end