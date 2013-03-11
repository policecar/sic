function B = bitplaneEncoding(A, cut)
%BITPLANEENCODER    Encodes a given 2-dimensional matrix A in Bit Plane 
%                   Coding and returns its bit stream.

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
    
    % set threshold to max value in A floored to the nearest power of 2
    threshold = max(max(A));
    threshold = 2^(floor(log2(threshold)));
    n = numel(A);
    L_up = zeros(size(A));  % a look-up table to store significant entries
    Aa = A;                 % a matrix to store shaved entry values
    
    % instantiate bit stream (to max required, cut off later on)
    steps = ceil(log2(threshold) - log2(cut));  % correct !?
    B = zeros(numel(A) * steps * 2, 1);
    ix = 1;     % index in bit stream
    idx = 1:n;  % order of matrix traversal, by column for now
    
    thr = threshold;
    
    % loop over threshold until cut is reached
    % in each loop and per pixel write either two significance bits or one
    % refinement bit to the bit stream
    while thr >= cut
      
        A_sig = zeros(size(A)); % instantiate matrix for significance val.
        A_ref = zeros(size(A)); % instantiate matrix for refinement values
        i = 1;
        while i <= numel(idx)
            
            % retrieve actual i value from idx(i)
            j = idx(i);

            % significance pass
            if (abs(A(j)) > thr) && ...
               (thr == threshold || abs(A(i)) <= thr*2)
                L_up(j) = 1; % mark significant entries
                % encode encountered value, cf. temporary coding above
                if sign(A(j)) == -1
                    A_sig(j) = 3;
                else
                    A_sig(j) = 2;
                end
                Aa(j) = Aa(j) - thr; % subtract current threshold
            end

            % refinement pass
            % if pixel has been significant before but not in this round,
            % evaluate and send refinement, else send significance value
            if L_up(j) == 1 && A_sig(j) == 0
                % make it pretty: dissect number into powers of 2, check
                % if log2(thr) is in that list
                if Aa(j) >= thr
                    A_ref(j) = 1;
                    Aa(j) = Aa(j) - thr;
                end
                B(ix,:) = A_ref(j);
                ix = ix+1;
            else
                % reverse temporary mapping, cf. temporary coding above
                tmp = A_sig(j);
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
            i = i+1;
        end
        thr = thr/2; % adapt threshold
    end
    B = B(1:ix-1,:);
       
end
