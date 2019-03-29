function ReducedKeypoints = FilterWithTaylor(Keypoints,Lowes,sigma_0,s)
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
        
        if blurs <= 3
            %b=blurs;
            Grad_sig = (Lowes{blurs+1,scale} - Lowes{blurs,scale});%(1/(sigma_0*2^((b+1)/s) - sigma_0*2^(b/s)))*(Lowes{blurs+1,scale} - Lowes{blurs,scale});
            H_sigsig = Lowes{blurs+2,scale} - 2*Lowes{blurs+1,scale} + Lowes{blurs,scale};
            %H_sigsig = (1/(sigma_0*2^((b+2)/s) - 2*sigma_0*2^((b+1)/s) + sigma_0*2^(b/s)))*(Lowes{blurs+2,scale}  ...
        else
            %b=blurs;
            %Grad_sig = (1/(sigma_0*2^((b+1)/s) - sigma_0*2^((b-1)/s)))*(Lowes{blurs+1,scale} - Lowes{blurs-1,scale});%
            %H_sigsig = (1/(sigma_0*2^((b+1)/s) - 2*sigma_0*2^(b/s) + sigma_0*2^((b-1)/s)))*(Lowes{blurs+1,scale}  ...
            %    - 2*Lowes{blurs,scale} + Lowes{blurs-1,scale});
            Grad_sig = (Lowes{blurs,scale} - Lowes{blurs-1,scale});
            H_sigsig =  Lowes{blurs-2,scale} - 2*Lowes{blurs-1,scale} + Lowes{blurs,scale};
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
    
    List = [];
    Selected = cell(size(Keypoints,1));
    count_selected = zeros(size(Keypoints,1),1);
    for blurs = 1:size(Keypoints,1)
        List = [List; blurs*ones(size(Keypoints{blurs,scale},1),1),...
            (1:size(Keypoints{blurs,scale},1))',...
            blurs*ones(size(Keypoints{blurs,scale},1),1)];
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
        
        %     for blurs = 1:size(Keypoints,1)
        %         point = 1;
        %         selected =[];
        %         while point <= size(Keypoints{blurs,scale},1)
        
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
                (abs(xhat(2)) <= 0.5) 
            d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
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
            if x~=size(Lowes{blurs,scale},2)
                Keypoints{blurs,scale}(point,1) = x + 1;
                List(1,3) = List(1,3)+1;
                continue
            end
        elseif xhat(1) < -0.5
            if x~=1
                Keypoints{blurs,scale}(point,1) = x - 1;
                List(1,3) = List(1,3)+1;
                continue
            end
        end
        
        if xhat(2) > 0.5
            if y~=size(Lowes{blurs,scale},1)
                Keypoints{blurs,scale}(point,2) = y + 1;
                List(1,3) = List(1,3)+1;
                continue
            end
        elseif xhat(2) < -0.5
            if y~=1
                Keypoints{blurs,scale}(point,2) = y - 1;
                List(1,3) = List(1,3)+1;
                continue
            end
        end
        
%         if xhat(3) > sigma_0*2^((blurs-1)/s)*(2^(1/s)-1)%0.5*(sigma_0*2^((blurs+1)/s) - sigma_0*2^(blurs/s))
%             
%             %Put in threshold
%             d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
%             if abs(d_xhat) < 0.03
%                 List(1,:) = [];
%                 %Keypoints{blurs,scale}(point,:) = [];
%                 continue;
%             end
%             if blurs == size(Keypoints,1)%For boundary
%                 List(1,:) = [];
%                 count_selected(blurs) = count_selected(blurs) + 1;
%                 Selected{blurs}(count_selected(blurs)) = point;
%                 %point=point+1;
%                 continue
%             else
%                 List(1,:) = [];
%                 List(end+1,:) = [blurs+1,...
%                     size(Keypoints{blurs+1,scale},1)+1,...
%                     iter+1];
%                 
%                 %Keypoints{blurs,scale}(point,:) = [];
%                 Keypoints{blurs+1,scale}(end+1,:) = [x,y];
%             end
%            
%         elseif xhat(3) < sigma_0*2^((blurs-2)/s)*(1-2^(1/s))
%             %Put in threshold
%             d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
%             if abs(d_xhat) < 0.03
%                 List(1,:) = [];
%                 %Keypoints{blurs,scale}(point,:) = [];
%                 continue;
%             end
%             if blurs == 1 %For boundary
%                 List(1,:) = [];
%                 %point = point+1;
%                 continue
%             else
%                 List(end+1,:) = [blurs-1,...
%                     size(Keypoints{blurs-1,scale},1)+1,...
%                     iter+1];
%                 %Keypoints{blurs,scale}(point,:) = [];
%                 Keypoints{blurs-1,scale}(end+1,:) = [x,y];
%             end
%             
%         else
%             %Put in threshold
%             d_xhat = Lowes{blurs,scale}(x,y) + 0.5*Gr_xy'*xhat;
%             if abs(d_xhat) < 0.03
%                 List(1,:) = [];
%                 %Keypoints{blurs,scale}(point,:) = [];
%                 continue;
%             end
%             List(1,:) = [];
%             count_selected(blurs) = count_selected(blurs) + 1;
%             Selected{blurs}(count_selected(blurs)) = point;
%         end
        
        
    end
    
%     for blurs = 1:size(Keypoints,1)
%         if (count_selected(blurs)>0)
%             Selected{blurs} = Selected{blurs}(1:count_selected(blurs));
%             Keypoints{blurs,scale} = Keypoints{blurs,scale}(Selected{blurs},:);
%         else
%             Keypoints{blurs,scale} = [];
%         end
%     end
    
end
ReducedKeypoints = Keypoints;
end

