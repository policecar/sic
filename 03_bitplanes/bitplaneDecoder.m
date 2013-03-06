function A = bitplaneDecoder(B, numPlanes, width, height)
%BITPLANEDECODER    Decodes a given bit stream B in Bit Plane Coding to a 
%                   2-dimensional matrix and returns that matrix.

    val = 2^numPlanes;
    A = zeros(width, height);
    L_up = zeros(size(A));

    % questions
    % do i know the size of the image?

    % bit stream comes in
    % i know that the first x signals are significance values
    % 00 01 10 11
    

    b = 1;
    c = 1;
    
    % significance bits only
    while b <= (width * height)
        if B(b) == 0
            % if B(b+1) == 0, do nothing bc we zeroed above
            if B(b+1) == 1
                % do nothing for now bc we're not using 01 yet
            end
        else    % if B(b) == 1
            if B(b+1) == 0
                L_up(c) = -1;
                A(c) = 1 * val;
            else    % if B(b+1) == 1
                L_up(c) = 1;
                A(c) = 1 * val;
            end
        end
        b = b+2;
    end
    
    while b <= numel(B)
        
       %
        
    end

end