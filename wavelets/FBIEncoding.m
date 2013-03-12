
function T = FBIEncoding(X)
%FBIENCODING    Discrete Wavelet Transformation of a 2-D image (encoding).
%               using the Debauchies wavelet.

    % fetch filters
    [a, d, ~, ~] = DebauchiesWavelet();
    
    T = zeros(size(X));
    
    % iteratively until size(X) = [2,2], do
    [~, n] = size(X);
    while n >= 2
    
        % symmetrically convolute X with filter a or d
        LP = sconv(a, X); %  low pass  > T(1:m,1:n) w/ m = n/2
        HP = sconv(d, X); % high pass  > T(m+1:n,1:n)

        LL = sconv(a, LP);
        LH = sconv(d, LP);
        HL = sconv(a, HP);
        HH = sconv(d, HP);
        
        % subsample
        LL = LL(2:2:end,2:2:end);
        LH = LH(2:2:end,1:2:end);
        HL = HL(1:2:end,2:2:end);
        HH = HH(1:2:end,1:2:end);
        T(1:n,1:n) = [LL,LH;HL,HH];
                
        % update
        n = n /2;
        X = T(1:n,1:n);

    end
end


