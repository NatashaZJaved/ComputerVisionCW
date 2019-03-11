function G = HessianGaussianBlurMatrix(N,sigma,Coord)
% If Coord == 0 then deriv w.r.t x
% If Coord == 1 then deriv w.r.t y
    G = zeros(2*N+1);
    for x = -N:N
        for y = -N:N
            if (Coord == 0)
                d = (4*x^2);
            else
                d = (4*y^2);
            end
            G(x+N+1,y+N+1) = d*(1/(2*pi*sigma^2))*exp(-0.5*(x^2+y^2)/sigma^2);
        end
    end
end
