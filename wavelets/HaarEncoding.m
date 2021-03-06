
function T = HaarEncoding(X)
%HAARENCODING   Discrete Wavelet Transformation of a 2-D image (encoding).
%               using the Haar wavelet.

    % define the Haar wavelet
    v = 1/sqrt(2);
    lp = [v;  v];   % Haar scaling function < low pass filter
    hp = [v; -v];   % Haar wavelet function < high pass filter

    % helper variables
    [~, n] = size(X);
    T = zeros(size(X));

    % iteratively until size(X) = [2,2], do
    while n >= 2
       
        % construct resp. Haar transform
        H = zeros([n, n]);
        m = n/2;
        j = 1;
        for i = 1:m
            H(j:j+1,i) = lp;
            H(j:j+1,i+m) = hp;
            j = j+2;
        end
        
        % filter
        T(1:n,1:n) = H' * X * H;

        % update
        n = n /2;
        X = T(1:n,1:n);
        
    end
end