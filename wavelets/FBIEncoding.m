
function T = FBIEncoding(X)
%FBIENCODING    Discrete Wavelet Transformation of a 2-D image (encoding).
%               using the Daubechies wavelet.

    % fetch filters
    [a, d, ~, ~] = DaubechiesWavelet();
    
    T = zeros(size(X));
    
    % iteratively until size(X) = [2,2], do
    [~, n] = size(X);
    while n >= 2
    
        % symmetrically convolute X with analysis filters a and d
        LP = sconv(a, X); % low pass
        HP = sconv(d, X); % high pass
        
        % transpose and convolute again
        LL = sconv(a, LP');
        LH = sconv(d, LP');
        HL = sconv(a, HP');
        HH = sconv(d, HP');
        
        % subsample and transpose back
        LL = LL(2:2:end,2:2:end)';
        LH = LH(1:2:end,2:2:end)';
        HL = HL(2:2:end,1:2:end)';
        HH = HH(1:2:end,1:2:end)';
        
        T(1:n,1:n) = [LL,LH;HL,HH];
        
        % update
        n = n /2;
        X = T(1:n,1:n);
    end
end
