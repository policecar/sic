
function Y = scale(X, minX, maxX)
%SCALE  Scales input data X to scale [min; max].

    Y = X - min(X(:));
    Y = (Y / range(Y(:))) * (maxX - minX);
    Y = Y + minX;

end