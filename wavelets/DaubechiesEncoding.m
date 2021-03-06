
function X = DaubechiesEncoding(X, a, d)
%DAUBECHIESENCODING		Discrete Wavelet Transformation, encoding part, 
%						of a 2-D image using the Daubechies wavelet.

	n = length(X);
	if n >= 2,		% recursively
	%while n >= 2,	% iteratively

		% symmetrically convolute X with analysis filters a and d
		LP = sconv(a, X(1:n,1:n));	% low pass
		HP = sconv(d, X(1:n,1:n));	% high pass

		% transpose, convolute, transpose
		LL = sconv(a, LP')';
		HL = sconv(a, HP')';
		LH = sconv(d, LP')';
		HH = sconv(d, HP')';

		% subsample
		% ie. discard detail columns for LP and coefficient columns for HP
		LL = LL(1:2:end,1:2:end);
		HL = HL(1:2:end,2:2:end);
		LH = LH(2:2:end,1:2:end);
		HH = HH(2:2:end,2:2:end);		
		
		% recursively
		X(1:n,1:n) = [DaubechiesEncoding(LL, a, d), HL; LH, HH];
		
		% iteratively
		%X(1:n,1:n) = [LL, HL; LH, HH];
		%n = n /2;

	end
end
