
function B = upsample(A)
%UPSAMPLE       Upsamples a 3-dimensional matrix by a factor of 2. 

    lil = ones(2,2);
    B = zeros(size(A) .* [2,2,1]);

    for i = 1:size(A,3)
        B(:,:,i) = kron(A(:,:,i),lil);
    end

end