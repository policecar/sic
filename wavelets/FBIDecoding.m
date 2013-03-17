
function T = FBIDecoding(T, as, ds)
%FBIDECODING    Discrete Wavelet Transformation of a 2-D image (decoding)
%               using Daubechies wavelets.

    % write 0 in every 2nd from 2 for LP, every 2nd from 1 for HP
    
    % upsamplers
    lil_LL = [1,0;0,0];
    lil_HL = [0,0;1,0];
    lil_LH = [0,1;0,0];
    lil_HH = [0,0;0,1];
    
    n = length(T);
    if n >= 2,
        
        % split T(1:n,1:n) into four quadrants
        m = n/2;
        Q1 = FBIDecoding(T(1:m,1:m), as, ds);
        Q2 = T(1:m,m+1:n);
        Q3 = T(m+1:n,1:m);
        Q4 = T(m+1:n,m+1:n);
        
        % upsample
        U1 = kron(Q1, lil_LL);
        U2 = kron(Q2, lil_HL);
        U3 = kron(Q3, lil_LH);
        U4 = kron(Q4, lil_HH);

        % transpose and convolute
        L1 = sconv(as, U1');  % low pass
        L2 = sconv(as, U2');  % high pass
        H1 = sconv(ds, U3');
        H2 = sconv(ds, U4');
                        
        % transpose and convolute again
        LL = sconv(as, L1');
        HL = sconv(ds, L2');
        LH = sconv(as, H1');
        HH = sconv(ds, H2');
        
        T = (LL + HL + LH + HH);
                
    end
%     T = 0.5 * T;
    
end