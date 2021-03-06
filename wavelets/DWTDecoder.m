
function Y = DWTDecoder(type, T)
%DWTDECODER     Discrete Wavelet Transform of a 2-D matrix (decoding) with
%               Haar wavelet if type is 0, Daubechies wavelet if type is 1.

    switch type
        case 0
            Y = HaarDecoding(T);
        case 1
            % fetch filters
            [~, ~, as, ds] = DaubechiesWavelet();
            Y = DaubechiesDecoding(T, as, ds);
    end
end