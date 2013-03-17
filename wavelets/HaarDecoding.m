
function T = HaarDecoding(T)
%HAARDECODING   Discrete Wavelet Transformation of a 2-D image (decoding) 
%               using the Haar wavelet.

    % define the Haar wavelet
    v = 1/sqrt(2);
    lp = [v;  v];   % Haar scaling function < low pass filter
    hp = [v; -v];   % Haar wavelet function < high pass filter

    % iteratively until n = size(T,1), do
    n = 2;
    while n <= size(T,1)

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
        T(1:n,1:n) = H * T(1:n,1:n) * H'; % note that here: H' = H^-1
        
        % update
        n = n *2;
        
    end
end