function [Keypoints_Oriented] = AssignOrientations(Keypoints, BlurredImages, sigma_0,s)
% Do that orientation stuff, the first one, not the second

Keypoints_Oriented = cell(size(Keypoints));
for scale = 1:size(Keypoints,2)
    box_size = 16; %16x16 grid
    for blurs = 1:size(Keypoints,1)
        for point = 1:size(Keypoints{blurs,scale},1)
            x = Keypoints{blurs,scale}(point,1);
            y = Keypoints{blurs,scale}(point,2);
            
            % Create orientation and magnitude stuff
            x_vec = x - box_size/2:x + box_size/2;
            y_vec = y - box_size/2:y + box_size/2;
            m = zeros(length(x_vec),length(y_vec));
            theta = m;
            
            % HIIISSTTTOOOGRRAMMM
            hist = zeros(36,1);
            
            for i = 1:length(x_vec)
                for j =  1:length(y_vec)
                    x_cur = x_vec(i); y_cur = y_vec(j);
                    
                    x_minus = x_cur - 1;
                    x_plus = x_cur + 1;
                    if (x_cur==1)
                        %mirror image
                        x_minus = x_cur;
                    elseif (x_cur==size(BlurredImages{blurs,scale},2))
                        x_plus = x_cur;
                        %mirror image
                    end
                    y_minus = y_cur - 1;
                    y_plus = y_cur + 1;
                    if (y_cur==1)
                        y_minus = y_cur;
                        %mirror image
                    elseif (y_cur==size(BlurredImages{blurs,scale},1))
                        y_plus = y_cur;
                        %mirror image
                    end
                    
                    m(i,j) = sqrt(...
                        (BlurredImages{blurs,scale}(x_plus,y_cur) - ...
                        BlurredImages{blurs,scale}(x_minus,y_cur))^2 + ...
                        (BlurredImages{blurs,scale}(x_cur,y_plus) - ...
                        BlurredImages{blurs,scale}(x_cur,y_minus))^2);
                    % RESULT IN REDIANS CONVERT
                    theta(i,j) = atan(...
                        (BlurredImages{blurs,scale}(x_cur,y_plus) - ...
                        BlurredImages{blurs,scale}(x_cur,y_minus))/...
                        (BlurredImages{blurs,scale}(x_plus,y_cur) - ...
                        BlurredImages{blurs,scale}(x_minus,y_cur)));
                end
            end
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

