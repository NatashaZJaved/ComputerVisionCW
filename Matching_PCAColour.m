function [Matched,count] = Matching_PCAColour(Test_Des, Object_Des,...
    Keypoints_Oriented_Object, Keypoints_Oriented_Test_Image)
% Matched stores both coord (x,y) of match point and ssd value

Matched = cell(size(Test_Des));
count = 0;
for blurs = 1:size(Test_Des,1)
    for scale = 1:size(Test_Des,2)
        for col = 1:3
            Matched{blurs,scale,col} = sparse(size(Test_Des{blurs,scale,col},1),5);
            if isempty(Test_Des{blurs,scale,col}) || isempty(Object_Des{blurs,scale,col})
                continue
            end
            num_pca_comp = 5;
            if (size(Test_Des{blurs,scale,col},1) > num_pca_comp) ...
                    && (size(Object_Des{blurs,scale,col},1) > num_pca_comp)
                [~,pca_full] = pca(Test_Des{blurs,scale,col});
                Test_Des{blurs,scale,col} = pca_full(:,1:num_pca_comp);
                [~,pca_full] = pca(Object_Des{blurs,scale,col});
                Object_Des{blurs,scale,col} = pca_full(:,1:num_pca_comp );
            end
            for test_point = 1:size(Test_Des{blurs,scale,col},1)
                
                if (size(Object_Des{blurs,scale,col},1)>0)
                    Tree = KDTreeSearcher(Object_Des{blurs,scale,col});
                    
                    Idx = knnsearch(Tree,Test_Des{blurs,scale,col}(test_point,:),'K',2);
                    
                    min_ssd_ind = Idx(1);
                    min_ssd = norm(Test_Des{blurs,scale,col}(test_point,:)...
                        - Object_Des{blurs,scale,col}(min_ssd_ind,:))^2;
                    
                    % Will not always get two as there may only be one point
                    % In Object_Des{blurs,scale}
                    if (length(Idx) > 1)
                        sec_min_ssd = norm(Test_Des{blurs,scale,col}(test_point,:)...
                            - Object_Des{blurs,scale,col}(Idx(2),:))^2;
                        
                        % Should change threshold
                        if ((min_ssd/sec_min_ssd)>0.8)
                            continue;
                        end
                    end
                    
                    if (min_ssd > 100)
                        continue;
                    end
                    
                    x_object = Keypoints_Oriented_Object{blurs,scale,col}(min_ssd_ind,1);
                    y_object = Keypoints_Oriented_Object{blurs,scale,col}(min_ssd_ind,2);
                    x_in_test_image = ...
                        Keypoints_Oriented_Test_Image{blurs,scale,col}(test_point,1);
                    y_in_test_image = ...
                        Keypoints_Oriented_Test_Image{blurs,scale,col}(test_point,2);
                    
                    Matched{blurs,scale,col}(test_point,:) = ...
                        [x_in_test_image,...
                        y_in_test_image,...
                        x_object,...
                        y_object,...
                        min_ssd];
                    
                    count = count + 1;
                end
            end
        end
    end
end







end