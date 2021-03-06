
function [a, d, as, ds] = DaubechiesWavelet()
%DAUBECHIESWAVELET  Construct filters corresponding to the Daubechies 
%                   wavelets.

    % Note: resolution wrt frequency increases with p (at the expense of 
    %       spatial resolution), p=4 seems a good compromise
    % for p = 4, M(z) = 
    % 2*u(z)^4 (  u(z)^3 + 7*u(z)^2*u(- z) + 21*u(z)*u( -z)^2 + 35* u(- z)^3  )
    
    % which can be derived as follows
    % find roots of polynomial
    u   = [ 1 2  1] ./4;
    u_  = [-1 2 -1] ./4;
    u2  = conv(u,u);
    u_2 = conv(u_,u_);
    m0  = conv(u,u2) + 7.*conv(u2,u_) + 21.*conv(u,u_2) + 35.*conv(u_,u_2);
    w   = roots(m0);

    % group to construct filters
    % (conjugate and inverse roots to same filter)
    as  = conv([-1 w(1)], [-1 w(6)]);
    a   = [1];
    for k = 2:5,
        a = conv(a, [-1 w(k)]);
    end
    
    % spread u(z)^4 to both filters
    as  = conv(as, u2);
    a   = conv(a, u2);
    
    % normalize lowpass filters
    as  = as ./ sum(as) .* sqrt(2);
    a   = real(a) ./ sum( real(a) ) .* sqrt(2);
    
    % generate resp. highpass filters
    d   = as;
    d(1:2:end) = -d(1:2:end);
    ds  = a;
    ds(2:2:end) = -ds(2:2:end);

end