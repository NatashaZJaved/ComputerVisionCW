function ReducedKeypoints = FilterWithTaylor(Keypoints,Lowes,sigma_0,s)
% Keypoints is a cell array with
% Keypoints{Blurs,subscale} = [x; y]
% where (x,y) is the coord of the point
% Blurs is the indice of scale (so Blurs = i means sigma_(i) blur)
% subscale is the amount of reduction of size
% so image is 2^(subscale)x smaller

% Find gradient at each keypoint
N = 2;

for scale = 1:size(Keypoints,2)
    for blurs = 1:size(Keypoints,1)
        
        sigma = sigma_0*2^(blurs/s);
        dGx = DerivGaussianBlurMatrix(N,sigma,0);
        Grad_x = filter2(dGx,Lowes{blurs,scale});
        dGy = DerivGaussianBlurMatrix(N,sigma,1);
        Grad_y = filter2(dGy,Lowes{blurs,scale});
        
        H_xx = filter2(dGx,Grad_x);
        H_xy = filter2(dGx,Grad_y); %H_yx = H_xy
        H_yy = filter2(dGy,Grad_y);
        H_sigsig = 0; %?
        H_sigx = 0; %?
        H_sigy = 0; %?
        
        for i=1:length(Keypoints{blurs,scale})
            H = [H_xx(x,y), H_xy(x,y), H_sigx(x,y); ...
                 H_xy(x,y), H_yy(x,y), H_sigy(x,y); ...
                 H_sigx(x,y), H_sigy(x,y), H_sigsig(x,y)];
        end
    end
end

end

