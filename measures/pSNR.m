
function p = pSNR(A, O, threshold)
%PSNR       Computes the Peak Signal-to-Noise ratio (PSNR) between a 
%           transformed image A and its original O.

    n = numel(A);
    ds = (O - A) .^2;                       % difference squared
    MSE = (1 /n) * sum(ds(:));              % mean squared error
    maxVal = 2^(ceil(log2(threshold))) -1;  % maximal possible value
    
    p = 10 * log((maxVal ^2) /MSE);         % -10 * log ( MSE / (maxVal^2))

end