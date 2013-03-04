
function B = subsample(A)
%SUBSAMPLE      Subsamples a 3-dimensional matrix by a factor of 2.

    B = A(1:2:end, 1:2:end, :);
    
end