function Y = scale(X, minimum, maximum)
%SCALE  Scales an input vector or matrix X to [minimum; maximum].

    Y = X - min(X(:));
    Y = (Y / range(Y(:))) * (maximum - minimum);
    Y = Y + minimum;

end
