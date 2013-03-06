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
    
    % instantiate bit stream (to max required, cut off later on)
    steps = ceil(log2(threshold) - log2(cut));  % correct !?
    B = zeros(numel(A) * steps * 2, 1);
    ix = 1;
    
    thr = threshold;
    L_up = zeros(size(A));  % a look-up table to store significant entries
    
    % loop over threshold until reaching cut
    % in each loop and per pixel write either two significance bits or a
    % single refinement bit to the bit stream
    % note to self: temporary coding: 0 -> 00, 1 -> 01, 2 -> 10, 3 -> 11
    % note to other: was told to use for loops :/
    while thr >= cut
      
        A_sig = zeros(size(A));
        A_ref = zeros(size(A));
        for i = 1:size(A,1)
            for j = 1:size(A,2)
               
                % significance pass
                if (abs(A(i,j)) > thr) && ...
                   (thr == threshold || abs(A(i,j)) <= thr*2)
                    L_up(i,j) = 1;
                    % mark if value has been significant before
                    % which is the case if it's value > threshold
                    if sign(A(i,j)) == -1
                        A_sig(i,j) = 3;
                    else
                        A_sig(i,j) = 2;
                    end
                end
                
                % refinement pass
                % if pixel has been significant but not in this round,
                % evaluate refinement
                if L_up(i,j) == 1 && A_sig(i,j) == 0
                    if A(i,j) >= thr    % !? might not be correct
                        A_ref(i,j) = 1;
                    end
                end
                
                % decide on bit stream value to transfer
                % if entry is significant but not in current round, use
                % refinement value, else use significance value
                if L_up(i,j) == 1 && A_sig(i,j) == 0
                    B(ix,:) = str2double(dec2bin(A_ref(i,j),1));
                    ix = ix+1;
                else
                    tmp = dec2bin(A_sig(i,j),2)';
                    B(ix,1) = str2double(tmp(1));
                    B(ix+1,1) = str2double(tmp(2));
                    ix = ix+2;
                end
                
            end
        end
        thr = thr/2;    % adapt threshold

    end
    B = B(1:ix-1,:);
    
    % write idiomatic matlab version ?
       
end
