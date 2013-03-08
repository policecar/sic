
function plot_bitplane(A, A_bpd, peak, cuts, threshold)
%PLOT_BITPLANE      Plots an image as well as its bit plane coded version,
%                   and the Peak Signal-to-Noise Ratio for different 
%                   cut levels /numbers of planes.

    figure,
    A = uint8(A);
    subplot(1,2,1), imshow(A);      % plot the original

    A_bpd = uint8(A_bpd);
    subplot(1,2,2), imshow(A_bpd);  % plot the bit plane version
    
    figure, plot(peak,'x-g');
    title('Peak Signal-to-Noise Ratio')
    xlabel('Number of planes'), 
    ylabel('Peak SNR in dB')
    set(gca,'YScale','log')
    xticks = (ceil(log2(threshold))) - log2(cuts);
    xticklabels = textscan(num2str(xticks),'%s');
    set(gca,'XTick', xticks)
    set(gca,'XTickLabel', xticklabels{1})
end