
function B = BitplaneEncoding(C1, C2, C3, maxIter)
%BITPLANEENCODER    Bit-Plane codes an image given in 3 separate channels 
%                   and returns its bit stream.

    % bit stream symbols:
    %   00    insignificant
    %   01    unknown as yet
    %   10    significant and positive 
    %   11    significant and negative
    
    % temporary significance coding:
    %   0     -> 00
    %   1     -> 01
    %   2     -> 10
    %   3     -> 11

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
    
    % instantiate some helper matrices
    L_up = zeros(size(A));  % look-up table to store significant entries
    Aa = A;                 % matrix to store shaved entry values

    idx = 1:m*n;    % order of matrix traversal, by column for now
    thr = th;       % need this for significance pass check
    
    for it = 1:maxIter % for every threshold
        for k = 1:d % for each of the channels in turn
            
            t = th(k);
            A_sig = zeros(size(A)); % helper matrix for significance pass
            A_ref = zeros(size(A)); % helper matrix for refinement pass

            for i = 1:numel(idx) % for every pixel

                % write data to bit stream

                j = idx(i); % retrieve actual index

                % significance pass
                if (abs(A(k,j)) > t) && ...
                   (t == thr(k) || abs(A(k,j)) <= t*2)
                    L_up(k,j) = 1; % mark as significant
                    % encode encountered value, cf. temporary coding above
                    if sign(A(k,j)) == -1
                        A_sig(k,j) = 3;
                    else
                        A_sig(k,j) = 2;
                    end
                    Aa(k,j) = Aa(k,j) - t; % subtract current threshold
                end

                % refinement pass
                % if pixel has been significant before but not in this round,
                % evaluate and send refinement, else send significance value
                if L_up(k,j) == 1 && A_sig(k,j) == 0
                    % make it pretty: dissect number into powers of 2, check
                    % if log2(thr) is in that list
                    if Aa(k,j) >= t
                        A_ref(k,j) = 1;
                        Aa(k,j) = Aa(k,j) - t;
                    end
                    B(ix,:) = A_ref(k,j);
                    ix = ix+1;
                else
                    % reverse temporary mapping, cf. temporary coding above
                    tmp = A_sig(k,j);
                    if tmp < 2
                        B(ix,1) = 0;
                        if tmp == 0
                            B(ix+1,1) = 0;
                        else
                            B(ix+1,1) = 1;
                        end
                    else
                        B(ix,1) = 1;
                        if tmp == 2
                            B(ix+1,1) = 0;
                        else
                            B(ix+1,1) = 1;
                        end
                    end
                    ix = ix+2;
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
