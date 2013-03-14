
function plot_bitplanes(A, A_bp)
%PLOT_BITPLANE      Plots an image given as 3-D matrix and its bit plane 
%                   coded version.

    figure,

    A = uint8(A);
    subplot(1,2,1), imshow(A);
    title('original image'),

    A_bp = uint8(A_bp);
    subplot(1,2,2), imshow(A_bp);
    title('bit plane transform'),

end