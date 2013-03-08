function main(fname)
%MAIN   Calls a day's code with the filename provided in fname if any.

    % set default filename
    if (nargin < 1)
        filename = 'clock.tiff';
    else
        filename = fname;
    end

    addpath('03_bitplanes');

    DATA_DIR = 'images/gray/';
    OUTPUT_DIR = 'output/';
    fmt = 'tiff';
    
    % load image
    A = imread(strcat(DATA_DIR, filename), fmt);
    
    % process image
    A = double(A);  % convert uint8 to double
    %A = [3 -4; -10, 11];
    [m,n] = size(A);
    cuts = [128,64,32,16,8,4,2,1];
    peak = zeros(size(cuts));
    threshold = max(max(A));
    A_bpd = zeros(size(A));
    for j = 1:numel(cuts)
        for i = 1:size(A,3)
            % encode matrix to bit plane encoding
            display('do bitplane encoding')
            tic
            A_bpe = bitplaneEncoder(A(:,:,i), cuts(j));
            toc
            % decode bit stream from bit plane decoding
            display('do bitplane decoding')
            tic
            A_bpd(:,:,i) = bitplaneDecoder(A_bpe, threshold, m, n);
            toc
        end
        % compute PSNR
        peak(j) = psnr(A, A_bpd, threshold);
    end
    
    % visualize transformed image
    plot_bitplane(A, A_bpd, peak, cuts, threshold)
    
    % save image
    imwrite(A_bpd, strcat(OUTPUT_DIR, 'bpd_', filename), fmt)

end