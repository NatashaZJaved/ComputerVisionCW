function ReducedKeypoints = FilterWithTaylorNoSigma(Keypoints,Lowes,sigma_0,s)
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
        Grad_x = filt_colours(dGx,Lowes{blurs,scale});
        dGy = DerivGaussianBlurMatrix(N,sigma,1);
        Grad_y = filt_colours(dGy,Lowes{blurs,scale});
        
        Gr{blurs,scale} = cell(2,1);
        Gr{blurs,scale}{1} = Grad_x;
        Gr{blurs,scale}{2} = Grad_y;
        
        H{blurs,scale} = cell(2);
        H{blurs,scale}{1,1} = filt_colours(dGx,Grad_x); %H_xx
        H{blurs,scale}{1,2} = filt_colours(dGx,Grad_y); %H_xy
        H{blurs,scale}{2,1} = H{blurs,scale}{1,2}; %H_yx
        H{blurs,scale}{2,2} = filt_colours(dGy,Grad_y); %H_yy
        
    end
end

for scale = 1:size(Keypoints,2)
    
    List = [];
    Selected = cell(size(Keypoints,1));
    count_selected = zeros(size(Keypoints,1),1);
    for blurs = 1:size(Keypoints,1)
        List = [List; blurs*ones(size(Keypoints{blurs,scale},1),1),...
            (1:size(Keypoints{blurs,scale},1))',...
            ones(size(Keypoints{blurs,scale},1),1)];
        Selected{blurs} = NaN(size(Keypoints{blurs,scale},1),1);
    end
    
    while ~isempty(List)
        disp(size(List))
        blurs = List(1,1);
        point = List(1,2);
        
        % If point has been checked too many times just forget it
        if (List(1,3) >= 3)
            List(1,:) = [];
            continue;
            %Keypoints{blurs,scale}(1,:) = [];
        end
        
        x = Keypoints{blurs,scale}(point,1);
        y = Keypoints{blurs,scale}(point,2);
        
        xhat = zeros(2,3);
        for col=1:3
            H_xy = [H{blurs,scale}{1,1}(x,y,col), H{blurs,scale}{1,2}(x,y,col); ...
                H{blurs,scale}{2,1}(x,y,col), H{blurs,scale}{2,2}(x,y,col)];

            Gr_xy = [Gr{blurs,scale}{1}(x,y,col); Gr{blurs,scale}{2}(x,y,col)];


            xhat(:,col) = -H_xy\Gr_xy;
        end
        
        % Good
        [d_xhat,colour] = min(Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat);
        xhat = xhat(:,colour);
        
        if (abs(xhat(1)) <= 0.5) &&...
                (abs(xhat(2)) <= 0.5)
            if abs(d_xhat) < 0.03
                %Keypoints{blurs,scale}(point,:) = [];
                List(1,:) = [];
                continue;
            end
            %Put in threshold
            count_selected(blurs) = count_selected(blurs) + 1;
            Selected{blurs}(count_selected(blurs)) = point;
            List(1,:) = [];
            %point = point + 1;
            continue;
        end
        
        % No good
        if xhat(1) > 0.5
            if x~=size(Lowes{blurs,scale},1)
                Keypoints{blurs,scale}(point,1) = x + 1;
                List(1,3) = List(1,3)+1;
                continue
            else
                List(1,3) = List(1,3)+1;
                continue
            end
        elseif xhat(1) < -0.5
            if x~=1
                Keypoints{blurs,scale}(point,1) = x - 1;
                List(1,3) = List(1,3)+1;
                continue
            else
                List(1,3) = List(1,3)+1;
                continue
            end
        end
        
        if xhat(2) > 0.5
            if y~=size(Lowes{blurs,scale},2)
                Keypoints{blurs,scale}(point,2) = y + 1;
                List(1,3) = List(1,3)+1;
                continue
            else
                List(1,3) = List(1,3)+1;
                continue
            end
        elseif xhat(2) < -0.5
            if y~=1
                Keypoints{blurs,scale}(point,2) = y - 1;
                List(1,3) = List(1,3)+1;
                continue
            else
                List(1,3) = List(1,3)+1;
                continue
            end
        end
    end
    for blurs = 1:size(Keypoints,1)
        if (count_selected(blurs)>0)
            Selected{blurs} = Selected{blurs}(1:count_selected(blurs));
            Keypoints{blurs,scale} = Keypoints{blurs,scale}(Selected{blurs},:);
        else
            Keypoints{blurs,scale} = [];
        end
    end
end
ReducedKeypoints = Keypoints;
end

