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

for scale = 1:size(Keypoints,2)
    for blurs = 1:size(Keypoints,1)
        
        sigma = sigma_0*2^(blurs/s);
        dGx = DerivGaussianBlurMatrix(N,sigma,0);
        Grad_x = filt_colours(dGx,Lowes{blurs,scale});
        dGy = DerivGaussianBlurMatrix(N,sigma,1);
        Grad_y = filt_colours(dGy,Lowes{blurs,scale});
        
        H{blurs,scale} = cell(3);
        H{blurs,scale}{1,1} = filt_colours(dGx,Grad_x); %H_xx
        H{blurs,scale}{1,2} = filt_colours(dGx,Grad_y); %H_xy
        H{blurs,scale}{2,1} = H{blurs,scale}{1,2}; %H_yx
        H{blurs,scale}{2,2} = filt_colours(dGy,Grad_y); %H_yy
    end
end

for scale = 1:size(Keypoints,2)
    for blurs = 1:size(Keypoints,1)
        point = 1;
        for col = 1:3
            while point <= size(Keypoints{blurs,scale,col},1)
                x = Keypoints{blurs,scale,col}(point,1);
                y = Keypoints{blurs,scale,col}(point,2);
                
                H_xy = [H{blurs,scale}{1,1}(x,y,col), H{blurs,scale}{1,2}(x,y,col); ...
                    H{blurs,scale}{2,1}(x,y,col), H{blurs,scale}{2,2}(x,y,col)];
                
                alpha = det(H_xy);
                if (alpha < 0)
                    Keypoints{blurs,scale,col}(point,:) = [];
                    continue;
                end
                
                r = 10;
                
                if (trace(H_xy)^2/det(H_xy) > (r+1)^2/r)
                    Keypoints{blurs,scale,col}(point,:) = [];
                    continue
                end
                
                point = point + 1;
            end
        end
    end
end
ReducedKeypoints = Keypoints;
end

