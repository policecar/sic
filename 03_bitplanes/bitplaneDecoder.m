function A = bitplaneDecoder(B, maxVal, width, height)
%BITPLANEDECODER    Decodes a given bit stream B in Bit Plane Coding to a 
%                   2-dimensional matrix and returns that matrix.

    % bit stream symbols:
    %   00    insignificant
    %   01    unknown as yet
    %   10    significant and positive 
    %   11    significant and negative
    
    threshold = 2^(floor(log2(maxVal)));
    A = zeros(width, height);
    n = width * height;
    L_up = zeros(size(A));

    b = 1;
    c = 1;    
    while b <= numel(B) % for every bit in bit stream
        while c <= n    % for every pixel
                    
            % if current bit belongs to pixel that hasn't been significant 
            % before, read two (significance) bits
            if L_up(c) == 0
                if B(b) == 0
                    % if B(b+1) == 0, do nothing bc we zeroed above
                    if B(b+1) == 1
                        % do nothing for now bc we're not using 01 yet
                    end
                else    % if B(b) == 1
                    if B(b+1) == 0
                        L_up(c) = 1;
                    else    % if B(b+1) == 1
                        L_up(c) = -1;
                    end
                    A(c) = threshold;   % strictly: 1* threshold
                end
                b = b+2;
            % elseif bit belongs to pixel that has been significant before,
            % read one (refinement) bit
            else
                if B(b) ~= 0
                    A(c) = A(c) + threshold;
                end
                b = b+1;
            end
            c = c+1;
        end
        c = 1;
        threshold = threshold /2;
    end
    
    % take care of sign, i.e. make originally negative numbers negative
    idx = find(L_up == -1);
    A(idx) = -1 .* A(idx);

end