
function main(filename)

    DATA_DIR = 'images/color/';
    OUTPUT_DIR = 'output/';
    fmt = 'tiff';

    % open image
    A = imread(strcat(DATA_DIR, filename), fmt);
    
    % visualize original image
    %imshow(A)

    % process image
    A_rgb = double(A);                      % convert uint8 to double
    A_yuv = rgb2yuv(A_rgb);                 % transform RGB to YUV
    A_420 = chroma_subsampler_420(A_yuv);   % chroma subsampling 4:2:0

    % visualize transformed image
    plot_yuv(A_yuv);
    plot_420(A_yuv, A_420);

    % save image
    imwrite(A_yuv, strcat(OUTPUT_DIR, 'yuv_', filename), fmt);
    imwrite(A_420, strcat(OUTPUT_DIR, '420_', filename), fmt);
