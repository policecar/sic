
function plot_wavelets(Y)
%PLOT_WAVELETS  Plots the Y channel of an image, its Haar and Daubechies 
%				encodings and transforms plus the difference between these
%				two encodings.
	
	H_enc = DWTEncoder(0, Y);
	H_dec = DWTDecoder(0, H_enc);
	D_enc = DWTEncoder(1, Y);
	D_dec = DWTDecoder(1, D_enc);
	
	figure,
	
	subplot(2,3,1), imshow(uint8(H_dec)),
	title('Haar transform')
	
	subplot(2,3,2), imshow(uint8(D_dec)),
	title('Daubechies transform')
	
	subplot(2,3,3), imshow(uint8(Y)),
	title('Original Y channel')
	
	subplot(2,3,4), imshow(uint8(H_enc*2)),
	title('Haar wavelet encoding')
	
	subplot(2,3,5), imshow(uint8(D_enc*2)),
	title('Daubechies wavelet encoding')
	
	Diff = scale(abs(H_enc - D_enc),0,255);
	subplot(2,3,6), imshow(uint8(Diff*10)),
	title('Diff b/w Haar and Daubechies encoding')

end