function G = DerivGaussianBlurMatrix(N,sigma,Coord)
% If Coord == 0 then deriv w.r.t x
% If Coord == 1 then deriv w.r.t y
N=ceil(2.5*sigma);
    G = zeros(2*N+1);
    for x = -N:N
        for y = -N:N
            if (Coord == 0)
                d = (x/sigma^2);
            else
                d = (y/sigma^2);
            end
            G(x+N+1,y+N+1) = d*(1/(2*pi*sigma^2))*exp(-0.5*(x^2+y^2)/sigma^2);
        end
    end
end

