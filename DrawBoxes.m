function Drawing = DrawBoxes(Keypoints, image)

% Draw boxes around features
Drawing = image;


Line_Mat = zeros(10000,10);
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
                    
                    shift_len = ceil(7*(2^(scale-1))/2);
                    c1 = [-shift_len+y_scaled;-shift_len+x_scaled];
                    c2 = [shift_len+y_scaled;-shift_len+x_scaled];
                    c3 = [-shift_len+y_scaled;shift_len+x_scaled];
                    c4 = [shift_len+y_scaled;shift_len+x_scaled];
                    
                    count = count + 1;
                    
                    Line_Mat(count,:) = [c1', c2', c4', c3', c1'];
                    
                end
            end
            
        end
    end
    
end

Drawing = insertShape(Drawing,'Line',Line_Mat(1:count,:));

end
