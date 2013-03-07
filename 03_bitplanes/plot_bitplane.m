function plot_bitplane(A, A_bpd)

    figure,
    A = uint8(A);
    subplot(1,2,1), imshow(A);

    A_bpd = uint8(A_bpd);
    subplot(1,2,2), imshow(A_bpd);

end