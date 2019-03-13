function [Keypoints_Oriented,Magnitude,Orientation] ...
    = AssignOrientations(Keypoints, BlurredImages, sigma_0,s)
% Do that orientation stuff, the first one, not the second

Keypoints_Oriented = cell(size(Keypoints));
Magnitude = cell(size(Keypoints));
Orientation = cell(size(Keypoints));

for scale = 1:size(Keypoints,2)
    box_size = 16; %16x16 grid
    for blurs = 1:size(Keypoints,1)
        
        Pre_grad = padarray(BlurredImages{blurs,scale},[1 1],'symmetric');
        Magnitude{blurs,scale} = sqrt((Pre_grad(3:end,2:end-1) - Pre_grad(1:end-2,2:end-1)).^2 + ...
            (Pre_grad(2:end-1,3:end) - Pre_grad(2:end-1,1:end-2)).^2);
        
        Orientation{blurs,scale} = atan2(Pre_grad(2:end-1,3:end) - Pre_grad(2:end-1,1:end-2), ...
            (Pre_grad(3:end,2:end-1) - Pre_grad(1:end-2,2:end-1)))*360/(2*pi);
        Orientation{blurs,scale}(Orientation{blurs,scale}==0) = 1;
        Orientation{blurs,scale}(isnan(Orientation{blurs,scale})) = 1; %When dividing by 0 - assume this just means the whole difference is 0
        Orientation{blurs,scale}(Orientation{blurs,scale}<0) = Orientation{blurs,scale}(Orientation{blurs,scale}<0)+360;
        
        for point = 1:size(Keypoints{blurs,scale},1)
            x = Keypoints{blurs,scale}(point,1);
            y = Keypoints{blurs,scale}(point,2);
            
            % Create orientation and magnitude stuff
            x_vec = max(x - box_size/2, 1):...
                min(x + box_size/2, size(BlurredImages{blurs,scale},1));
            y_vec = max(y - box_size/2, 1):...
                min(y + box_size/2, size(BlurredImages{blurs,scale},2));
            m = Magnitude{blurs,scale}(x_vec,y_vec);
            theta = Orientation{blurs,scale}(x_vec,y_vec);
            
            % HIIISSTTTOOOGRRAMMM
            hist = zeros(36,1);
            
            which_bin = ceil(theta./10);
            sigma = sigma_0*2^(blurs/s);
            G = GaussianBlurMatrix(box_size/2,sigma*1.5);
            m = filter2(G,m);
            
            for i = 1:size(m,1)
                for j = 1:size(m,2)
                    hist(which_bin(i,j)) = hist(which_bin(i,j)) + m(i,j);
                end
            end
            
            good_bin = max(hist);
            list = find(hist>0.8*good_bin);
            
            for i=1:length(list)
                Keypoints_Oriented{blurs,scale} = ...
                    [Keypoints_Oriented{blurs,scale}; x,y,hist(list(i))];
            end
        end
        
        
        
    end
end




end

