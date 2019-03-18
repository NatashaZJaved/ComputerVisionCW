function Descriptors = Descriptors(Keypoints_Oriented,Magnitude,Orientation,BlurredImages)
% Get the 128 length descriptors for every keypoint
Descriptors = cell(size(Keypoints_Oriented));

% Loop across keypoints 
% Draw Box
% Make histogram
% Store histogram

for scale = 1:size(Keypoints_Oriented,2)
    box_size = 16; %16x16 grid
    for blurs = 1:size(Keypoints_Oriented,1)
        
        
        for point = 1:size(Keypoints_Oriented{blurs,scale},1)
            x = Keypoints_Oriented{blurs,scale}(point,1);
            y = Keypoints_Oriented{blurs,scale}(point,2);
            
            % Create orientation and magnitude stuff. Point is at the
            % bottom right
            x_vec = max(x - 8, 1):...
                min(x + 7, size(BlurredImages{blurs,scale},1));
            y_vec = max(y - 8, 1):...
                min(y + 7, size(BlurredImages{blurs,scale},2));
        end
        
    end
end



end

