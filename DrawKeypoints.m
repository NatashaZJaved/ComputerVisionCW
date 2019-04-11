function Drawing = DrawKeypoints(Keypoints, image)

Drawing = image;
Circle_Mat = zeros(10000,3);
count = 0;
for blurs = 1:size(Keypoints,1)
    
    for scale = 1:size(Keypoints,2)
        
        for col = [1,3,2]
            
            if (~isempty(Keypoints{blurs,scale,col}))
                
                for point = 1:size(Keypoints{blurs,scale,col},1)
                    
                    x_scaled = (2^(scale-1))*Keypoints{blurs,scale,col}(point,1);
                    y_scaled = (2^(scale-1))*Keypoints{blurs,scale,col}(point,2);
                    
%                     if (col == 1)
%                         color = 'red';
%                     elseif (col == 2)
%                         color = 'green';
%                     else
%                         color = 'blue';
%                     end
                    
                    count = count + 1; 
                    Circle_Mat(count,:) = [y_scaled x_scaled,1];
                       
                end
            end
        end
    end
    
end

Drawing = insertShape(Drawing,'FilledCircle',Circle_Mat(1:count,:));
%imshow(Drawing);