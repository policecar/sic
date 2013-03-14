
function T = FBIDecoding(T)
%FBIDECODING    Discrete Wavelet Transformation of a 2-D image (decoding)
%               using Daubechies wavelets.

    % fetch filters
    [~, ~, as, ds] = DaubechiesWavelet();

    % write 0 in every 2nd from 2 for LP, every 2nd from 1 for HP
    
    % upsamplers
    lil_LL = [1,0;0,0];
    lil_HL = [0,0;1,0];
    lil_LH = [0,1;0,0];
    lil_HH = [0,0;0,1];
        
    % iteratively until n = size(T,1), do
    n = 2;
    while n <= size(T,1)
        
        % split T(1:n,1:n) into four quadrants
        m = n/2;
        LL0 = T(1:m,1:m);
        HL0 = T(1:m,m+1:n);
        LH0 = T(m+1:n,1:m);
        HH0 = T(m+1:n,m+1:n);
        
        % upsample
        LL1 = kron(LL0, lil_LL);
        HL1 = kron(HL0, lil_HL);
        LH1 = kron(LH0, lil_LH);
        HH1 = kron(HH0, lil_HH);
        
        % transpose and convolute
        LL2 = sconv(as, LL1');  % low pass
        HL2 = sconv(as, HL1');  % high pass
        LH2 = sconv(ds, LH1');
        HH2 = sconv(ds, HH1');
                        
        % transpose and convolute again
        LL = sconv(as, LL2');
        HL = sconv(ds, HL2');
        LH = sconv(as, LH2');
        HH = sconv(ds, HH2');
        
        T(1:n,1:n) = (LL + HL + LH + HH);
        n = n *2;
                
    end
    
end