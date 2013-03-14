
function [A, Planes] = BitplaneDecoding(B)
%BITPLANEDECODER    Decodes a given bit stream B in Bit Plane Coding to a 
%                   3-dimensional matrix and returns that matrix.

    % bit stream symbols:
    %   00    insignificant
    %   01    zero tree (unused yet)
    %   10    significant and positive 
    %   11    significant and negative
    
    % instantiate some helper variables
    d = 3;              % number of channels
    w = zeros(d,1);     % widthes
    h = zeros(d,1);     % heights
    th = zeros(d,1);    % thresholds
    
    % parse bitstream info for each of the channels
    ib = 3* 8;  % number of info bits per channel
    for k = 1:d
        [w(k), h(k), th(k)] = parseBitstreamInfo(B, ib);
        B = B(ib+1:end); % remove parsed info from stream
    end
    
    % instantiate more helper variables
    n = w(1) * h(1);        % assuming all channels share dimensionality
    A = zeros(d, w(1), h(1));
    L_up = zeros(size(A));  % a look-up matrix which stores significance
    pl = log2(max(th(:)));
    Planes = zeros(d,pl,w(1),h(1));

    b = 1;
    while b <= (numel(B) - 3*n) % for every bit in the stream
        for k = 1:d % for every channel in turn
            for c = 1:n % for every pixel

                % if pixel is significant, read two significance bits
                if L_up(k,c) == 0
                    if B(b) == 0,
                        % if B(b+1) ==0, L_up(k,c) = 0; end  << implicitly
                        if B(b+1) == 1,
                            % do nothing yet
                        end
                    else
                        if B(b+1) == 0
                            L_up(k,c) = 1;
                        else
                            L_up(k,c) = -1;
                        end
                        A(k,c) = th(k);
                    end
                    b = b+2;
                % elseif pixel has been significant, read a refinement bit
                else
                    if B(b) == 1
                        A(k,c) = A(k,c) + th(k);
                    end
                    b = b+1;
                end
            end
            th(k) = th(k) /2; % adjust channel-specific threshold
            Planes(k,pl,:,:) = A(k,:,:);
        end
        pl = pl-1;
    end
    
    % take care of sign, i.e. make originally negative numbers negative
    idx = find(L_up == -1);
    A(idx) = -1 .* A(idx);
    A = permute(A, [2,3,1]); % re-arrange dimensions to match [w,h,chan]

end


function [w,h,th] = parseBitstreamInfo(bitstream, ib)
%GETBITSTREAMINFO   Returns width, height and threshold of a given 2-D
%                   image channel from their 8-bit representations.
    
    bpi = ib /3;
    w  = 2^ bin2dec(num2str(bitstream(1:bpi)'));
    h  = 2^ bin2dec(num2str(bitstream(bpi+1:2*bpi)'));
    th = 2^ bin2dec(num2str(bitstream(2*bpi+1:3*bpi)'));
    
end
