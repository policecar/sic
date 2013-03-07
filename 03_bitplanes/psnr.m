function p = psnr(A, A_bp, threshold)
%PSNR       Computes the Peak Signal-to-Noise ratio (PSNR)

    n = numel(A);
    ds = (A_bp - A) ^2;                     % the difference squared
    MSE = (1 /n) * sum(ds(:));              % the mean squared error
    maxVal = 2^(floor(log2(threshold))) -1; % the maximal possible value
    
    p = -10 * log(MSE / (maxVal ^2));

end