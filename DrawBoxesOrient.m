function Drawing = DrawBoxesOrient(Keypoints, image)
%Need to use reducedreducedkeypoints for this 
Drawing = image;


Line_Mat = cell(10000,1);
count = 0;

for blurs = 1:size(Keypoints,1)
    
    for scale = 1:size(Keypoints,2)
        
        for col = [1,3,2]
            if (~isempty(Keypoints{blurs,scale,col}))
                
                for point = 1:size(Keypoints{blurs,scale,col},1)
                    
                    x_scaled = (2^(scale-1))*Keypoints{blurs,scale,col}(point,1);
                    y_scaled = (2^(scale-1))*Keypoints{blurs,scale,col}(point,2);
                    theta = Keypoints{blurs,scale,col}(point,3);
                    
%                     if (col == 1)
%                         color = 'red';
%                     elseif (col == 2)
%                         color = 'green';
%                     else
%                         color = 'blue';
%                     end
%                     
                    shift_len = ceil(7*(2^(scale-1))/2);
                    c1 = [-shift_len;-shift_len];
                    c2 = [shift_len;-shift_len];
                    c3 = [-shift_len;shift_len];
                    c4 = [shift_len;shift_len];
                    
                    box_orient = [2*shift_len;0];
                    box_arrow_1 = [2*shift_len-5;5];
                    box_arrow_2 = [2*shift_len-5;-5];
                    
                    
                    
                    Rotate_Mat = [cosd(theta),-sind(theta);sind(theta), cosd(theta)];
                    c1=Rotate_Mat*c1 + [y_scaled;x_scaled];
                    c2=Rotate_Mat*c2 + [y_scaled;x_scaled];
                    c3=Rotate_Mat*c3 + [y_scaled;x_scaled];
                    c4=Rotate_Mat*c4 + [y_scaled;x_scaled];
                    
                    middle=[y_scaled;x_scaled];
                    box_orient=Rotate_Mat*box_orient + [y_scaled;x_scaled];
                    box_arrow_1 = Rotate_Mat*box_arrow_1 + [y_scaled;x_scaled];
                    box_arrow_2 = Rotate_Mat*box_arrow_2 + [y_scaled;x_scaled];
                    
                    count = count + 1;
                    Line_Mat{count} = [c1', c2', c4', c3', c1'];
                    count = count + 1;
                    Line_Mat{count} = [middle', box_orient'];
                    count = count + 1;
                    Line_Mat{count} = [box_arrow_1', box_orient', box_arrow_2'];
                    
%                     Drawing = insertShape(Drawing,'Line',[c1', c2', c4', c3', c1']...
%                         ,'Color',color);
%                     Drawing = insertShape(Drawing,'Line',[middle', box_orient']...
%                         ,'Color',color);                    
%                     Drawing = insertShape(Drawing,'Line',[box_arrow_1', box_orient', box_arrow_2']...
%                         ,'Color',color);                       
                    
                end
            end                

        end
    end
    
end

Drawing = insertShape(Drawing,'Line',Line_Mat(1:count));

end
