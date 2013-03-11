
function A = BitplaneDecoding(B)
%BITPLANEDECODER    Decodes a given bit stream B in Bit Plane Coding to a 
%                   2-dimensional matrix and returns that matrix.

    % bit stream symbols:
    %   00    insignificant
    %   01    unknown as yet
    %   10    significant and positive 
    %   11    significant and negative
    
    % instantiate some helper variables
    d = 3; % apparently I need to know the dimensionality of the image
    w = zeros(d,1);
    h = zeros(d,1);
    th = zeros(d,1);
    
    % parse bitstream info for each of the three channels
    ib = 3* 8;  % number of info bits per channel
    for k = 1:d
        [w(k), h(k), th(k)] = parseBitstreamInfo(B, ib);
        B = B(ib+1:end); % remove parsed info from stream
    end
    
    % instantiate more helper variables
    n = w(1) * h(1); % assuming all channels share dimensionality
    A = zeros(d, w(1), h(1));
    L_up = zeros(size(A));

    b = 1;
    cnt = 0;
    while b <= (numel(B) - 3*n) % for every bit in the stream
        for k = 1:d % for every channel in turn
            cnt = cnt+1;
            for c = 1:n % for every pixel

                % if current bit belongs to pixel that wasn't significant 
                % yet, read two (significance) bits
                if L_up(k,c) == 0
                    if B(b) == 0
                        % if B(b+1) == 0, do nothing bc we zeroed above
                        if B(b+1) == 1
                            % do nothing for now bc we're not using 01 yet
                        end
                    else    % if B(b) == 1
                        if B(b+1) == 0
                            L_up(k,c) = 1;
                        else    % if B(b+1) == 1
                            L_up(k,c) = -1;
                        end
                        A(k,c) = th(k);
                    end
                    b = b+2;
                % elseif bit belongs to pixel that has been significant 
                % before, read one (refinement) bit
                else
                    if B(b) ~= 0
                        A(k,c) = A(k,c) + th(k);
                    end
                    b = b+1;
                end
%                 if b >= numel(B), break; end  % !?
            end
            th(k) = th(k) /2;       % adjust channel-specific threshold
        end
    end
    
    % take care of sign, i.e. make originally negative numbers negative
    idx = find(L_up == -1);
    A(idx) = -1 .* A(idx);
    A = permute(A, [2,3,1]); % re-arrange dimensions to match [w,h,chan]

end


function [w,h,th] = parseBitstreamInfo(bitstream, ib)
%GETBITSTREAMINFO   Returns width, height and threshold of a given 2-D
%                   image channel from its 8-bit representation.
    
    bpi = ib /3;
    w  = 2^ bin2dec(num2str(bitstream(1:bpi)'));
    h  = 2^ bin2dec(num2str(bitstream(bpi+1:2*bpi)'));
    th = 2^ bin2dec(num2str(bitstream(2*bpi+1:3*bpi)'));
    
end
