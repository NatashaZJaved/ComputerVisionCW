function [Matched,count] = Matching(Test_Des, Object_Des,Keypoints_Oriented_Object)
% Matched stores both coord (x,y) of match point and ssd value

Matched = cell(size(Test_Des));
count = 0;
for blurs = 1:size(Test_Des,1)
    for scale = 1:size(Test_Des,2)
        Matched{blurs,scale} = NaN(size(Test_Des{blurs,scale},1),3);
        
        for test_point = 1:size(Test_Des{blurs,scale},1)
            
            if (size(Object_Des{blurs,scale},1)>0)
                % THIS BIT TO CHANGE
                Tree = KDTreeSearcher(Object_Des{blurs,scale});
                
                Idx = knnsearch(Tree,Test_Des{blurs,scale}(test_point,:),'K',2);
                
                min_ssd_ind = Idx(1);
                min_ssd = norm(Test_Des{blurs,scale}(test_point,:)...
                    - Object_Des{blurs,scale}(min_ssd_ind,:))^2;
                
                % Will not always get two as there may only be one point
                % In Object_Des{blurs,scale}
                if (length(Idx) > 1)
                    sec_min_ssd = norm(Test_Des{blurs,scale}(test_point,:)...
                        - Object_Des{blurs,scale}(Idx(2),:))^2;
                    
                    % Should change threshold
                    if ((min_ssd/sec_min_ssd)>0.8)
                        continue;
                    end
                end
                
                if (min_ssd > 100)
                    continue;
                end
                
                x = Keypoints_Oriented_Object{blurs,scale}(min_ssd_ind,1);
                y = Keypoints_Oriented_Object{blurs,scale}(min_ssd_ind,2);
                Matched{blurs,scale}(test_point,:) = [x,y,min_ssd];
                count = count + 1;
            end
        end
        
    end
end







end