
function H = sconv(Filter, Matrix)
%SCONV      Row-wise symmetric convolution of a filter given as row vector 
%           with a matrix.
    
    % helper variables
    n = length(Matrix); % length of input matrix
    f = length(Filter); % length of filter
    l = f + n - 1;      % length of symmetrically extended matrix
    fhalbe = (f-1)/2;	% length of half the filter (ceiled)
    z = 2 * n - 2;		% length of circular index
    
    % symmetric extension
    E = zeros(n,l);
	for col = 1:length(E),

		i =  mod((col - 1) - fhalbe, z) + 1; % get z index of pixel value 
											 % to copy
        j = n - abs(i - n);		% map index to actual index in Matrix
        E(:,col) = Matrix(:,j);	% copy respective column to extended matrix

	end
	
    % convolute
    H = conv2(Filter, E);
    
    % trim matrix
    H = H(:,2*fhalbe+1:2*fhalbe+n);
    
end