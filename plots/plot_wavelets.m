
function plot_wavelets(Y, wavelet)
%PLOT_WAVELETS  Plots the original Y channel, its wavelet encoding and its
%               wavelet transform (Haar or Daubechies).
	
	figure,
	
	Y_enc = DWTEncoder(Y, wavelet);
	Y_dec = DWTDecoder(Y_enc, wavelet);
	
	subplot(2,2,1), imshow(uint8(Y)),
	title('Original Y channel')
	
	subplot(2,2,2), imshow(uint8(Y_enc*10)),
	title('Wavelet encoded Y channel')
	
	subplot(2,2,3), imshow(uint8(Y_dec)),
	title('Wavelet transformed Y channel')
	
	subplot(2,2,4), imshow(uint8((abs(Y - Y_dec)*10))),
	title('Diff b/w original and wavelet transform')
	
end