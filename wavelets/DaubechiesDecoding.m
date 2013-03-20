
function T = DaubechiesDecoding(T, as, ds)
%DAUBECHIESDECODING		Discrete Wavelet Transformation, decoding part, 
%						of a 2-D image using Daubechies wavelets.
	
	% recursively decode
	n = length(T);
 	if n >= 2,
	
		% split T(1:n,1:n) into four quadrants
		m = n/2;
		Q1 = DaubechiesDecoding(T(1:m,1:m), as, ds);
		Q2 = T(1:m,m+1:n);
		Q3 = T(m+1:n,1:m);
		Q4 = T(m+1:n,m+1:n);

		% upsample
		U1 = kron(Q1, [1;0]);
		U2 = kron(Q2, [1;0]);
		U3 = kron(Q3, [0;1]);
		U4 = kron(Q4, [0;1]);
		
		% transpose, convolute, transpose
		L1 = sconv(as, U1')';	% low pass
		L2 = sconv(as, U2')';	% high pass
		H1 = sconv(ds, U3')';
		H2 = sconv(ds, U4')';

		% upsample
		L1 = kron(L1, [1,0]);
		L2 = kron(L2, [0,1]);
		H1 = kron(H1, [1,0]);
		H2 = kron(H2, [0,1]);

		% convolute
		LL = sconv(as, L1);
		HL = sconv(ds, L2);
		LH = sconv(as, H1);
		HH = sconv(ds, H2);

		T = (LL + HL + LH + HH);
		
	end
	
end
