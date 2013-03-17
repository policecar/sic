
function X = FBIEncoding(X, a, d)
%FBIENCODING    Discrete Wavelet Transformation of a 2-D image (encoding).
%               using the Daubechies wavelet.

    % recursively compute wavelet coefficients
    n = length(X);
    if n >= 2
    
        % symmetrically convolute X with analysis filters a and d
        LP = sconv(a, X(1:n,1:n)); % low pass
        HP = sconv(d, X(1:n,1:n)); % high pass
        
        % transpose, convolute again, transpose again
        LL = sconv(a, LP')';
        HL = sconv(a, HP')';
        LH = sconv(d, LP')';
        HH = sconv(d, HP')';
        
        % subsample
        LL = LL(1:2:end,1:2:end);
        HL = HL(2:2:end,1:2:end);
        LH = LH(1:2:end,2:2:end);
        HH = HH(2:2:end,2:2:end);

        X(1:n,1:n) = [FBIEncoding(LL, a, d), HL; LH, HH];
        
    end
end
