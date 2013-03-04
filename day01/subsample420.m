
function B = subsample(A)
%SUBSAMPLE420       Subsamples a 3-dimensional matrix by a factor of 2
%                   and returns it.

    B = A(1:2:end, 1:2:end, :);
    
end