
function plot_RD(A)
%PLOT_RD    Plot the rate-distortion as the rate in bit per pixel over the
%           peak signal-to-noise ratio for bit plane codings with different
%           number of bit planes.

% Erzeuge eine D(R) Kurve, die den PSNR über die Rate aufträgt. 
% Die Rate sei die Anzahl an Bits je Pixel und der PSNR wird zwischen 
% Y,U und V in 3 einzelnen Kurven bestimmt. Um unterschiedliche Messpunkte 
% zu erhalten variiere die MaxIterations des Encoders von 1 bis 15. 

    p = 7;
    psnr = zeros(3,p);
    rd = zeros(1,p);
    numPix = numel(A);
    
    for i = 1:p, % for different numbers of bit planes

        % get Bitstream from BitplaneEncoding
        BS = BitplaneEncoding(A(:,:,1), A(:,:,2), A(:,:,3), i);
        numBits = (length(BS) - 3*3*8);
        rd(i) = numBits / numPix;

        % get transformed image from BitplaneDecoding
        Ac = BitplaneDecoding(BS);
        for j = 1:3, % for each channel
            psnr(j,i) = pSNR(Ac(:,:,j), A(:,:,j), max(max(A(:,:,j))));
        end

    end

    figure, 
    hold on
    plot(rd,psnr(1,:),'x-r'),
    plot(rd,psnr(2,:),'x-g'),
    plot(rd,psnr(3,:),'x-b'),
    
    title('pSNR over bits per pixel'),
    xlabel('Bitrate'),
    ylabel('Peak SNR in dB'),
    
    set(gca,'YScale','log')
        
end