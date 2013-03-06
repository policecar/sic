
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
    addpath('03_bitplanecoding');

    OUTPUT_DIR = 'output/';
    fmt = 'tiff';


%     %% day 1
%     DATA_DIR = 'images/color/';
% 
%     % open image
%     A = imread(strcat(DATA_DIR, filename), fmt);
% 
%     % visualize original image
%     %imshow(A)
% 
%     % process image
%     A_rgb = double(A);                  % convert uint8 to double
%     A_yuv = rgb2yuv(A_rgb);             % transform RGB to YUV
%     [A_420, up] = subsampler420(A_yuv); % chroma subsampling 4:2:0
% 
%     % visualize transformed image
%     plot_yuv(A_yuv);
%     plot_420(A_yuv, A_420, up);
% 
%     % save image
%     imwrite(A_yuv, strcat(OUTPUT_DIR, 'yuv_', filename), fmt);
%     imwrite(A_420, strcat(OUTPUT_DIR, '420_', filename), fmt);


    %% day 3
    DATA_DIR = 'images/gray/';
    
    % load image
    A = imread(strcat(DATA_DIR, filename), fmt);
    
    % process image
    A = double(A);  % convert uint8 to double
    cut = 1;
    A_bpd = zeros(size(A));
    for i = 1:size(A,3)
        % encode matrix to bit plane encoding
        A_bpe = bitplaneEncoder(A(:,:,i), cut);
        % decode bit stream from bit plane decoding
        A_bpd(:,:,i) = bitplaneDecoder(A_bpe, cut, size(A,1), size(A,2));
        % compute PSNR
        %peak = psnr(A_bpe);
    end
    
    % visualize transformed image
    plot_bitplane(A, A_bpd)
    
    % save image
    %imwrite(A_bpe, strcat(OUTPUT_DIR, 'bpe_', filename), fmt)
        