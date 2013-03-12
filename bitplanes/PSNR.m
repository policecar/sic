function p = psnr(A, A_bp, threshold)
%PSNR       Computes the Peak Signal-to-Noise ratio (PSNR)

    n = numel(A);
    ds = (A_bp - A) .^2;                    % difference squared
    MSE = (1 /n) * sum(ds(:));              % mean squared error
    maxVal = 2^(ceil(log2(threshold))) -1;  % maximal possible value
    
    p = 10 * log((maxVal ^2) /MSE); % i.e. -10 * log ( MSE / (maxVal^2))

end