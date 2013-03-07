function plot_bitplane(A, A_bpd, peak)

    figure,
    A = uint8(A);
    subplot(1,2,1), imshow(A);

    A_bpd = uint8(A_bpd);
    subplot(1,2,2), imshow(A_bpd);
    
    figure, plot(peak,'x-g');
    title('Peak Signal-to-Noise Ratio')
    xlabel('Number of planes'), ylabel('Peak SNR')
    set(gca,'YScale','log')
    set(gca,'XTick', [2,3,4,5,6,7])
    set(gca,'XTickLabel',{'1','2','3','4','5','6'})

end