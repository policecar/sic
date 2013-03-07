function main(fname)
%MAIN   Calls a day's code with the filename provided in fname if any.

    % set default filename
    if (nargin < 1)
        filename = 'baboon.tiff';
    else
        filename = fname;
    end

    addpath('01_farbraeume');

    DATA_DIR = 'images/color/';
    OUTPUT_DIR = 'output/';
    fmt = 'tiff';

    % open image
    A = imread(strcat(DATA_DIR, filename), fmt);

    % process image
    A_rgb = double(A);                  % convert uint8 to double
    display('tranform image to YUV')
    A_yuv = rgb2yuv(A_rgb);             % transform RGB to YUV
    display('do chroma subsampling 4:2:0')
    [A_420, up] = subsampler420(A_yuv); % chroma subsampling 4:2:0

    % visualize transformed image
    plot_yuv(A_yuv);
    plot_420(A_yuv, A_420, up);

    % save image
    imwrite(A_yuv, strcat(OUTPUT_DIR, 'yuv_', filename), fmt);
    imwrite(A_420, strcat(OUTPUT_DIR, '420_', filename), fmt);

end