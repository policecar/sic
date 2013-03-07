function B = bitplaneEncoder(A, cut)
%BITPLANEENCODER    Encodes a given 2-dimensional matrix A in Bit Plane 
%                   Coding and returns its bit stream.

    % bit stream symbols:
    %   00    insignificant
    %   01    unknown as yet
    %   10    significant and positive 
    %   11    significant and negative

    % set threshold to max value in A floored to the nearest power of 2
    threshold = max(max(A));
    threshold = 2^(floor(log2(threshold)));
    n = numel(A);
    L_up = zeros(size(A));  % a look-up table to store significant entries
    Aa = A; % matrix for refinement decisions
    
    % instantiate bit stream (to max required, cut off later on)
    steps = ceil(log2(threshold) - log2(cut));  % correct !?
    B = zeros(numel(A) * steps * 2, 1);
    ix = 1;
    
    thr = threshold;
    
    % loop over threshold until reaching cut
    % in each loop and per pixel write either two significance bits or a
    % single refinement bit to the bit stream
    while thr >= cut
      
        A_sig = zeros(size(A));
        A_ref = zeros(size(A));
        i = 1; 
        while i <= n

            % significance pass
            if (abs(A(i)) > thr) && ...
               (thr == threshold || abs(A(i)) <= thr*2)
                L_up(i) = 1;
                % mark if value has been significant before
                % which is the case if it's value > threshold
                if sign(A(i)) == -1
                    A_sig(i) = 3;
                else
                    A_sig(i) = 2;
                end
                Aa(i) = Aa(i) - thr;
            end

            % refinement pass
            % if pixel has been significant but not in this round,
            % evaluate refinement
            if L_up(i) == 1 && A_sig(i) == 0
                % make it pretty: dissect number into powers of 2, check
                % if log2(thr) is in that list
                %if A(i) >= thr     % incorrect! but interesting enough
                if Aa(i) >= thr
                    A_ref(i) = 1;
                    Aa(i) = Aa(i) - thr;
                end
            end

            % decide on bit stream value to transfer
            % if entry has been significant but not in current round, 
            % use refinement value, else use significance value
            if L_up(i) == 1 && A_sig(i) == 0
                B(ix,:) = A_ref(i);
                ix = ix+1;
            else
                % reverse mapping: 0 -> 00, 1 -> 01, 2 -> 10, 3 -> 11
                tmp = A_sig(i);
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
        thr = thr/2;    % adapt threshold
    end
    B = B(1:ix-1,:);
       
end
