function [Y, U, V] = subsampling420(A)
%SUBSAMPLING_420    Chroma-subsamples an image given as 3-D matrix in YUV 
%                   color space at a ratio of 4:2:0.
    
    % keep original Y, subsample U and V
    Y = A(:,:,1);
    U = A(1:2:end,1:2:end,2);
    V = A(1:2:end,1:2:end,3);
    
end