
function H = sconv(Filter, Matrix)
%SCONV      Row-wise symmetric convolution of a filter with a matrix 
%			(aka row-wise local weighted averaging).
    
    % helper variables
    n = length(Matrix);		% length of input matrix
    f = length(Filter);		% length of filter
    l = f + n - 1;			% length of symmetrically extended matrix
    hf = (f - 1) / 2;		% length of half the filter (ceiled)
    z = 2 * n - 2;			% length of circular index, e.g. cbabcd
    
    % symmetric extension
    E = zeros(n,l);			% extended matrix
	for col = 1:length(E),

		i =  mod((col - 1) - hf, z) + 1; % get z index of pixel to copy
        j = n - abs(i - n);		% map z index to index in Matrix
        E(:,col) = Matrix(:,j);	% copy respective M column to E matrix

	end
	
    % convolute
	H = conv2(E, Filter, 'valid');
    
end