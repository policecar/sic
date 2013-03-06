function plot_bitplane(A, A_bpe)

    figure,
    A = uint8(A);
    subplot(1,2,1), imshow(A);

    A_bpe = uint8(A_bpe);
    subplot(1,2,2), imshow(A_bpe);

end