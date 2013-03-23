
function [C1, C2, C3] = BitplaneDecoding(Bitstream)
%BITPLANEDECODER    Decodes a given bit stream in Bit Plane Coding to 
%                   a 3-dimensional matrix and returns that matrix.

    % bit stream symbols:
    %   00    insignificant
    %   01    zero tree (unused yet)
    %   10    significant and positive 
    %   11    significant and negative
    
    % helper variables
    d = 3;              % number of output channels
    ptr = 1;
    sz = zeros(d,2);    % sizes of channels
    th = zeros(d,1);    % thresholds
    
    % parse bitstream info header for each channel
    ib = 3* 8;          % number of info bits per channel
    for k = 1:d
        header = Bitstream(((k-1)*ib)+1:k*ib);
        [sz(k,1), sz(k,2), th(k)] = parseHeader(header);
    end
    ptr = ptr + 3*ib;
    
    % moa helper variables
    Channel = cell(1,3);     % outgoing data
    Channel{1} = zeros(sz(1));
    Channel{2} = zeros(sz(2));
    Channel{3} = zeros(sz(3));
    Lookup = Channel;       % significance map
    pMax = 99;              % assume a max of 99 bit planes
    n = sz(:,1) .* sz(:,2); % number of elements per channel
    
    p = pMax - 1;
    while ptr < length(Bitstream),
        for k = 1:d, % for every channel in turn
			
			lup = Lookup{k};
			chan = Channel{k};
			
			for c = 1:n(k), % for every pixel

                % if pixel is significant, read two significance bits
                if lup(c) == 0
                    
                    % if significant
                    if Bitstream(ptr) == 1,
                        
                        % if positive significant
                        if Bitstream(ptr+1) == 0,
                            lup(c) = 1;
                            chan(c) = th(k);
                        
                        % if negative significant
                        else
                            lup(c) = 1;
                            chan(c) = -th(k);
                        end
                        
                    % if insignificant    
                    else
                        
                        if Bitstream(ptr+1) == 0,
                            % do nothing
                        else 
                            display('do not panic')
                        end
                        
                    end
                    ptr = ptr+2;

                % if pixel has been significant, read a refinement bit
                else
                    
                    if Bitstream(ptr) == 1
                        chan(c) = chan(c) + sign(chan(c)) * th(k);
                    end
                    ptr = ptr+1;
                    
                end
			end
			% update variables
            th(k) = th(k) /2; % adjust channel-specific threshold
			Channel{k} = chan;
			Lookup{k} = lup;
        end
    end
    
    % cell to matrices
    C1 = Channel{1}; C2 = Channel{2}; C3 = Channel{3};

end


function [w,h,th] = parseHeader(header)
%GETBITSTREAMINFO   Returns width, height and threshold of a given 2-D
%                   image channel from their 8-bit representations.
    
    i = 8;
    w  = 2^ bin2dec(num2str(header(1:i)'));
    h  = 2^ bin2dec(num2str(header(i+1:2*i)'));
    th = 2^ bin2dec(num2str(header(2*i+1:3*i)'));
    
end
