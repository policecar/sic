
function plot_psnr(peak, maxVal, cut)
%PLOT_PSNR      Plots the Peak Signal-to-Noise Ratio for several cut offs.

    figure,
    plot(peak,'x-g');
    
    title('Peak Signal-to-Noise Ratio');
    xlabel('Number of planes'), 
    ylabel('Peak SNR in dB')
    
    set(gca,'YScale','log')
    
    xticks = (ceil(log2(maxVal))) - log2(cut);
    xticklabels = textscan(num2str(xticks),'%s');
    set(gca,'XTick', xticks)
    set(gca,'XTickLabel', xticklabels{1})

end