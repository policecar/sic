
function T = DWTEncoder(type, X)
%DWTENCODER     Discrete Wavelet Transform of a 2-D matrix (encoding) with
%               Haar wavelet if type is 0, Daubechies wavelet if type is 1.

    switch type
        case 0
            T = HaarEncoding(X);
        case 1
            % fetch filters
            [a, d, ~, ~] = DaubechiesWavelet();
            T = DaubechiesEncoding(X, a, d);
    end
end