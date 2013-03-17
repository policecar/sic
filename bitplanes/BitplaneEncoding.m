
function Bitstream = BitplaneEncoding(C1, C2, C3, maxIter)
%BITPLANEENCODER    Given three separate 2-D channels of an image (with 
%                   potentially different dimensions) and the number of 
%                   bit planes to encode, performs bit plane encoding 
%                   and produces an (intertwined) bitstream.

    % bit stream symbols:
    %   00    insignificant
    %   01    zero tree (unused as yet)
    %   10    significant and positive 
    %   11    significant and negative
        
    % helper variables
    d = 3;              % number of input channels
    threshold = zeros(1,3);    % set thresholdresholds
    threshold(1) = 2^(floor(log2(max(abs(C1(:))))));
    threshold(2) = 2^(floor(log2(max(abs(C2(:))))));
    threshold(3) = 2^(floor(log2(max(abs(C3(:))))));
    N = [numel(C1), numel(C2), numel(C3)];
    Channel = cell(1,3);     % incoming data
    Channel{1} = C1; Channel{2} = C2; Channel{3} = C3;
    Remainder = Channel;     % helper copy for shaved values 

    % instantiate bitstream (to max required, cut off later on)
    ib = 3* 8;          % number of info bits per channel
    Bitstream = zeros(ib *d + sum(N) *2 *maxIter, 1, 'uint8');
    ptr = 1;             % current index in bitstream
    
    % write info to bitstream
    for k = 1:d
        ie = k * ib;
        Bitstream(ptr:ie) = getBitstreamInfo(size(Channel{k}), ...
            threshold(k))';
        ptr = ptr + ib; %rename to ptr
    end
    
    for it = 1:maxIter % for every threshold
        for k = 1:d % for each of the channels in turn
            
            t = threshold(k);

            for j = 1:N(k) % for every pixel

                % write data to bit stream

                % if pixel hasn't been significant, send two significance
                % bits
                if Channel{k}(j) == Remainder{k}(j),
                    
                    % if positive significant
                    if Channel{k}(j) >= t,
                        Bitstream(ptr)   = 1;
                        Bitstream(ptr+1) = 0;
                        Remainder{k}(j) = Remainder{k}(j) - t;
                    
                    % if negative significance
                    elseif Channel{k}(j) <= -t,
                        Bitstream(ptr)   = 1;
                        Bitstream(ptr+1) = 1;
                        Remainder{k}(j) = Remainder{k}(j) + t;
                    
                    % if insignificant
                    else
                        Bitstream(ptr)   = 0;
                        Bitstream(ptr+1) = 0;                        
                    end
                    ptr = ptr + 2;
                    
                % if pixel has been significant (but not in this round), 
                % send one refinement bit
                else
                    
                    if Remainder{k}(j) >= t,
                        Bitstream(ptr) = 1;
                        Remainder{k}(j) = Remainder{k}(j) - t;
                
                    elseif Remainder{k}(j) <= -t,
                        Bitstream(ptr) = 1;
                        Remainder{k}(j) = Remainder{k}(j) + t;
                    
                    else
                        Bitstream(ptr) = 0;
                    end
                    ptr = ptr + 1;
                end
                
            end
            threshold(k) = threshold(k) /2; % update threshold
        end
    end
    Bitstream = Bitstream(1:ptr-1,:);
end


function info = getBitstreamInfo(szChan, threshold)
%GETBITSTREAMINFO   Returns 8-bit representations of width, height and 
%                   threshold of a given 2-D image channel.
    
    width = dec2bin(log2(szChan(1)),8) - '0';
    height = dec2bin(log2(szChan(2)),8) - '0';
    threshold = dec2bin(log2(threshold),8) - '0';
    info = [width, height, threshold];

end
