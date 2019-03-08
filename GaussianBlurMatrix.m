function [G] = GaussianBlurMatrix(N,sigma)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    %We have a (2n+1)*(2n+1) filter
    G = zeros(2*N+1);
    for x = -N:N
        for y = -N:N
            G(x+N+1,y+N+1) = (1/(2*pi*sigma^2))*exp(-0.5*(x^2+y^2)/sigma^2);
        end
    end
end

