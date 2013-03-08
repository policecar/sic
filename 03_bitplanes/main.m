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
    %A = [183 -4; -10.2, 11.5];
    cuts = [128,64,32,16,8,4,2,1];
    %cuts = [64];
    sz = size(A);
    peak = zeros(size(cuts));
    A_bpd = zeros(sz);
    for j = 1:numel(cuts)
        for i = 1:size(A,3) % (don't use sz(3), will throw error)
            % encode matrix to bit plane encoding
            display('Bit plane encoding')
            tic
            Bs = bitplaneEncoder(A(:,:,i), cuts(j));
            toc
            % decode bit stream from bit plane decoding
            display('Bit plane decoding')
            tic
            threshold = max(max(A(:,:,i)));
            A_bpd(:,:,i) = bitplaneDecoder(Bs, threshold, sz(1), sz(2));
            toc
        end
        % compute PSNR
        peak(j) = psnr(A, A_bpd, threshold);
    end
    
    % visualize transformed image
    plot_bitplane(A, A_bpd, peak, cuts, threshold)
    
    % save image
    imwrite(A_bpd, strcat(OUTPUT_DIR, 'bpd_', filename), fmt)
    
    % save image
    imwrite(A_bpd, strcat(OUTPUT_DIR, 'bpd_', filename), fmt)

end