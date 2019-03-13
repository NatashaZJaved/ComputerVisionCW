function ReducedKeypoints = FilterWithTaylor(Keypoints,Lowes,sigma_0,s)
% Keypoints is a cell array with
% Keypoints{Blurs,subscale} = [x; y]
% where (x,y) is the coord of the point
% Blurs is the indice of scale (so Blurs = i means sigma_(i) blur)
% subscale is the amount of reduction of size
% so image is 2^(subscale)x smaller


%%%%%%% COME BACK TO THIS REGARDING WHILE LOOP %%%%%%%%%%%%


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
        
        if blurs == 1
            Grad_sig = Lowes{blurs,scale};
            H_sigsig = Grad_sig;
        elseif blurs == size(Keypoints,1)
            Grad_sig = Lowes{blurs,scale};
            H_sigsig = Grad_sig;
        else
            Grad_sig = 0.5*(Lowes{blurs+1,scale} - Lowes{blurs-1,scale});
            H_sigsig = 0.25*(Lowes{blurs+1,scale}  ...
                - 2*Lowes{blurs,scale} + Lowes{blurs-1,scale});
        end
        
        Gr{blurs,scale} = cell(3,1);
        Gr{blurs,scale}{1} = Grad_x;
        Gr{blurs,scale}{2} = Grad_y;
        Gr{blurs,scale}{3} = Grad_sig;
        
        H{blurs,scale} = cell(3);
        H{blurs,scale}{1,1} = filter2(dGx,Grad_x); %H_xx
        H{blurs,scale}{1,2} = filter2(dGx,Grad_y); %H_xy
        H{blurs,scale}{1,3} = filter2(dGx,Grad_sig); %H_sigx
        H{blurs,scale}{2,1} = H{blurs,scale}{1,2}; %H_yx
        H{blurs,scale}{2,2} = filter2(dGy,Grad_y); %H_yy
        H{blurs,scale}{2,3} = filter2(dGy,Grad_sig); %H_sigy
        H{blurs,scale}{3,1} = H{blurs,scale}{1,3}; %H_sigx
        H{blurs,scale}{3,2} = H{blurs,scale}{2,3}; %H_sigy
        H{blurs,scale}{3,3} = H_sigsig; %H_sigsig
        
    end
end
        
for scale = 1:size(Keypoints,2)
    for blurs = 1:size(Keypoints,1)
        point = 1;

        while point <= size(Keypoints{blurs,scale},1)

            x = Keypoints{blurs,scale}(point,1);
            y = Keypoints{blurs,scale}(point,2);
            
            
            H_xy = [H{blurs,scale}{1,1}(x,y), H{blurs,scale}{1,2}(x,y), ...
                H{blurs,scale}{1,3}(x,y); ...
                H{blurs,scale}{2,1}(x,y), H{blurs,scale}{2,2}(x,y), ...
                H{blurs,scale}{2,3}(x,y); ...
                H{blurs,scale}{3,1}(x,y), H{blurs,scale}{3,2}(x,y), ...
                H{blurs,scale}{3,3}(x,y)];
            
            Gr_xy = [Gr{blurs,scale}{1}(x,y); Gr{blurs,scale}{2}(x,y);...
                Gr{blurs,scale}{3}(x,y)];
            
            xhat = -H_xy\Gr_xy;
            
            % Good
            if (abs(xhat(1)) <= 0.5) &&...
                    (abs(xhat(2)) <= 0.5) &&...
                    (abs(xhat(3)) <= 0.5)
                d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
                if abs(d_xhat) < 0.03
                   Keypoints{blurs,scale}(point,:) = []; 
                   continue;
                end
                %Put in threshold
                point = point + 1;
                continue;
            end
            
            % No good
            if xhat(1) > 0.5
                if x~=size(Lowes{blurs,scale},2) 
                    Keypoints{blurs,scale}(point,1) = x + 1;
                end
            elseif xhat(1) < -0.5
                if x~=1
                    Keypoints{blurs,scale}(point,1) = x - 1;
                end
            end
            
            if xhat(2) > 0.5
                if y~=size(Lowes{blurs,scale},1) 
                    Keypoints{blurs,scale}(point,2) = y + 1;
                end
            elseif xhat(2) < -0.5
                if y~=1
                    Keypoints{blurs,scale}(point,2) = y - 1;
                end
            end
            
            if xhat(3) > 0.5*(sigma_0*2^(blurs+1/s) - sigma_0*2^(blurs/s))
                
                %Put in threshold
                d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
                if abs(d_xhat) < 0.03
                    Keypoints{blurs,scale}(point,:) = [];
                   continue;
                end
                if blurs == size(Keypoints,1)%For boundary
                    point=point+1;
                    continue
                else
                    Keypoints{blurs,scale}(point,:) = [];
                    Keypoints{blurs+1,scale}(end+1,:) = [x,y];
                end
                
            elseif xhat(3) < 0.5*(sigma_0*2^(blurs-1/s) - sigma_0*2^(blurs/s))
                %Put in threshold
                d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
                if abs(d_xhat) < 0.03
                    Keypoints{blurs,scale}(point,:) = [];
                   continue;
                end  
                if blurs == 1 %For boundary
                    point = point+1;
                    continue
                else
                    Keypoints{blurs,scale}(point,:) = [];
                    Keypoints{blurs-1,scale}(end+1,:) = [x,y];
                end
                
            else
                %Put in threshold
                d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
                if abs(d_xhat) < 0.03
                   Keypoints{blurs,scale}(point,:) = []; 
                   continue;
                end                
                point=point+1;
            end
            
        end
    end
end
ReducedKeypoints = Keypoints;
end

