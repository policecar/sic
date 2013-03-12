
function B = BitplaneEncoding(C1, C2, C3, maxIter)
%BITPLANEENCODER    Bit-Plane codes an image given in 3 separate channels 
%                   and returns its bit stream.

    % bit stream symbols:
    %   00    insignificant
    %   01    zero tree (unused as yet)
    %   10    significant and positive 
    %   11    significant and negative
    
    % (note: function signature is heteronomous)
    % merge channels into single matrix 
    A(1,:,:) = C1; A(2,:,:) = C2; A(3,:,:) = C3;
    [d, m, n] = size(A);
    th = zeros(d,1);
    
    % instantiate bitstream (to max required, cut off later on)
    ib = 3* 8;  % number of info bits per channel
    B = zeros(ib *3 + numel(A) *2 *maxIter, 1);  % length of info + data
    ix = 1;  % current index in bitstream
    
    % write info to bitstream
    for k = 1:d
        th(k) = 2^(floor(log2(max(abs(A(k,:)))))); % set threshold
        ie = k * ib;
        B(ix:ie) = getBitstreamInfo(A(k,:,:), th(k))';
        ix = ix + ib;
    end
    
    Aa = A;         % a helper matrix to store shaved entry values
    idx = 1:m*n;    % order of matrix traversal, by column for now
    
    for it = 1:maxIter % for every threshold
        for k = 1:d % for each of the channels in turn
            
            t = th(k);

            for i = 1:numel(idx) % for every pixel

                % write data to bit stream

                j = idx(i); % retrieve actual index

                % if pixel is significant, send two significance bits
                if A(k,j) == Aa(k,j), % if pixel has not been significant
                    if abs(A(k,j)) >= t, % if pixel is significant now
                        B(ix) = 1;
                        if sign(A(k,j)) == -1, % if value is sub-zero
                            B(ix+1) = 1;
                            Aa(k,j) = Aa(k,j) + t;
                        else
                            B(ix+1) = 0;
                            Aa(k,j) = Aa(k,j) - t;
                        end
                    else
                        B(ix) = 0;
                        B(ix+1) = 0;
                    end
                    ix = ix+2;
                % else send a single refinement bit
                elseif abs(A(k,j)) > abs(Aa(k,j))+t,
                    if abs(Aa(k,j)) >= t,
                        B(ix) = 1;
                        if sign(A(k,j)) == -1,
                            Aa(k,j) = Aa(k,j) + t;
                        else
                            Aa(k,j) = Aa(k,j) - t;
                        end
                    else
                        B(ix) = 0;
                    end
                    ix = ix+1;
                end
            end
            th(k) = th(k) /2; % update threshold
        end
    end
    B = B(1:ix-1,:);
end


function info = getBitstreamInfo(Chan, th)
%GETBITSTREAMINFO   Returns an 8-bit representation of width, height and 
%                   threshold of a given 2-D image channel.
    
    [~, m, n] = size(Chan);
    w = dec2bin(log2(m),8) - '0';
    h = dec2bin(log2(n),8) - '0';
    th = dec2bin(log2(th),8) - '0';
    info = [w, h, th];

end
