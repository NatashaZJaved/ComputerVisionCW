function ReducedKeypoints = FilterWithHessian(Keypoints,Lowes,sigma_0,s)
% Keypoints is a cell array with
% Keypoints{Blurs,subscale} = [x; y]
% where (x,y) is the coord of the point
% Blurs is the indice of scale (so Blurs = i means sigma_(i) blur)
% subscale is the amount of reduction of size
% so image is 2^(subscale)x smaller


% Find gradient at each keypoint
N = 2;

H = cell(size(Lowes));
Gr = H;
for scale = 1:size(Keypoints,2)
    for blurs = 1:size(Keypoints,1)
        
        sigma = sigma_0*2^(blurs/s);
        dGx = DerivGaussianBlurMatrix(N,sigma,0);
        Grad_x = filter2(dGx,Lowes{blurs,scale});
        dGy = DerivGaussianBlurMatrix(N,sigma,1);
        Grad_y = filter2(dGy,Lowes{blurs,scale});
        
        H{blurs,scale} = cell(3);
        H{blurs,scale}{1,1} = filter2(dGx,Grad_x); %H_xx
        H{blurs,scale}{1,2} = filter2(dGx,Grad_y); %H_xy
        H{blurs,scale}{2,1} = H{blurs,scale}{1,2}; %H_yx
        H{blurs,scale}{2,2} = filter2(dGy,Grad_y); %H_yy
    end
end

for scale = 1:size(Keypoints,2)
    for blurs = 1:size(Keypoints,1)
        point = 1;
        while point <= size(Keypoints{blurs,scale},1)
            x = Keypoints{blurs,scale}(point,1);
            y = Keypoints{blurs,scale}(point,2);
            
            H_xy = [H{blurs,scale}{1,1}(x,y), H{blurs,scale}{1,2}(x,y); ...
                H{blurs,scale}{2,1}(x,y), H{blurs,scale}{2,2}(x,y)];
            
            alpha = det(H_xy);
            if (alpha < 0)
                 Keypoints{blurs,scale}(point,:) = [];
                 continue;
            end
            
            r = 10;
          
            if (trace(H_xy)^2/det(H_xy) > (r+1)^2/r)
                Keypoints{blurs,scale}(point,:) = [];
                continue
            end
            point = point + 1;
        end
    end
end
ReducedKeypoints = Keypoints;
end

