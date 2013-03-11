
function B = rgb2yuv( A )
%RGB2YUV    Transforms a 3-dimensional matrix in RBG color space
%           to YUV color space and returns it.

    % YUV transform
    YUV = [
         0.299  0.587  0.114;
        -0.147 -0.289  0.436;
         0.615 -0.515 -0.100
    ];

    % transform RGB to YUV color space
    sz = size(A);
    A = reshape(A, sz(1)*sz(2), []);
    B = (YUV * A')';
    B = reshape(B, sz);
    
end