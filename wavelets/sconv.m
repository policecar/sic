
function h = sconv(f,g)
%SCONV      Symmetric convolution of f and g where f is a row vector and g
%           is a matrix.

    % some helper variables
    len = numel(f);
    ext = floor(len /2);
    
    % if filter f exceeds size of matrix g, cut it on both ends
    % 
    if ext >= size(g,2),
        k = size(g,2) - 1;  % size of mirror-able part
        ctr = ceil(len /2); % the filter's center (assuming odd-length)
        f = f(1,ctr-k:ctr+k);
        ext = k;
    end
    
    % symmetrically extend g by half the length of f
    lext = fliplr(g(:,2:ext+1));
    rext = fliplr(g(:,end-ext:end-1));
    g = [lext, g, rext];

    % symmetrically convolute g with f
    h = conv2(f,g);

    % remove symmetric extensions as well as matlab 0 cushioning
    h = h(:,1+2*ext:end-2*ext);

end