
function B = yuv2rgb(A)
%YUV2RGB    Transforms a 3-dimensional matrix in YUV color space
%           to RGB color space and returns it.

    % RGB transform
    RGB = [
         0.299  0.587  0.114;
        -0.147 -0.289  0.436;
         0.615 -0.515 -0.100
    ]^-1;

    % transform YUV to RGB color space
    sz = size(A);
    A = reshape(A, sz(1)*sz(2), []);
    B = (RGB * A')';
    B = reshape(B, sz);
    
end