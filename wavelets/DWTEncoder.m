
function T = DWTEncoder(X, type)
%DWTENCODER     Discrete Wavelet Transform of a 2-D matrix (encoding) with
%               Haar wavelet if type is 0, Daubechies wavelet if type is 1.

    switch type
        case 0
            T = HaarEncoding(X);
        case 1
            T = FBIEncoding(X);
    end
end