function [Matched,...
    Test_Des_No_Blurs, ...
    Keypoints_Oriented_Test_Image_No_Blurs, ...
    Object_Des_No_Blurs, ...
    Keypoints_Oriented_Object_No_Blurs]...
    = Matching_PCAColoursNew(Test_Des, Object_Des,...
    Keypoints_Oriented_Object, Keypoints_Oriented_Test_Image)
% Matched stores both coord (x,y) of match point and ssd value

Matched = cell(size(Test_Des,2),3);

Test_Des_No_Blurs = cell(size(Test_Des,2),3);
Keypoints_Oriented_Test_Image_No_Blurs = cell(size(Test_Des,2),3);

Object_Des_No_Blurs = cell(size(Object_Des,2),3);
Keypoints_Oriented_Object_No_Blurs = cell(size(Object_Des,2),3);

% FORGET BLURS
for scale = 1:size(Test_Des,2)
    count_blurs_vec_object = zeros(size(Test_Des,1));
    count_blurs_vec_test = zeros(size(Test_Des,1));
    for col = 1:3
        for blurs = 1:size(Test_Des,1)
            n_points_in_blurs = size(Test_Des{blurs,scale,col},1);
            Test_Des_No_Blurs{scale,col} = [Test_Des_No_Blurs{scale,col};...
                Test_Des{blurs,scale,col}] ;
            Keypoints_Oriented_Test_Image_No_Blurs{scale,col} = [...
                Keypoints_Oriented_Test_Image_No_Blurs{scale,col}; ...
                Keypoints_Oriented_Test_Image{blurs,scale,col}];
            count_blurs_vec_test(blurs) = n_points_in_blurs;
            
            n_points_in_blurs = size(Object_Des{blurs,scale,col},1);
            Object_Des_No_Blurs{scale,col} = [Object_Des_No_Blurs{scale,col};...
                Object_Des{blurs,scale,col}];
            Keypoints_Oriented_Object_No_Blurs{scale,col} = [...
                Keypoints_Oriented_Object_No_Blurs{scale,col}; ...
                Keypoints_Oriented_Object{blurs,scale,col}];
            count_blurs_vec_object(blurs) = n_points_in_blurs;
        end
        
        Keypoints_Oriented_Test_Image_No_Blurs{scale,col}...
            = sortrows(Keypoints_Oriented_Test_Image_No_Blurs{scale,col});
        
        Keypoints_Oriented_Object_No_Blurs{scale,col}...
            = sortrows(Keypoints_Oriented_Object_No_Blurs{scale,col});
    end
end



for scale = 1:size(Test_Des,2)
    for col = 1:3
        Matched{scale,col} = NaN(size(Test_Des_No_Blurs{scale,col},1),5);
        if isempty(Test_Des_No_Blurs{scale,col}) || isempty(Object_Des_No_Blurs{scale,col})
            continue
        end
%         num_pca_comp = 20;
%         if (size(Test_Des_No_Blurs{scale,col},1) > num_pca_comp) ...
%                 && (size(Object_Des_No_Blurs{scale,col},1) > num_pca_comp)
%             [~,pca_full] = pca(Test_Des_No_Blurs{scale,col});
%             Test_Des_No_Blurs{scale,col} = pca_full(:,1:num_pca_comp);
%             [~,pca_full] = pca(Object_Des_No_Blurs{scale,col});
%             Object_Des_No_Blurs{scale,col} = pca_full(:,1:num_pca_comp );
%         end
        test_point = 1;
        
        while test_point <= size(Test_Des_No_Blurs{scale,col},1)
            
            x_in_test_image = ...
                Keypoints_Oriented_Test_Image_No_Blurs{scale,col}(test_point,1);
            y_in_test_image = ...
                Keypoints_Oriented_Test_Image_No_Blurs{scale,col}(test_point,2);
            
            end_point = ...
                length(find(ismember(Keypoints_Oriented_Test_Image_No_Blurs{scale,col}(:,1:2)...
                ,[x_in_test_image, y_in_test_image],'rows')));
            
            min_ssd = inf;
            for i = 1:end_point
                if (size(Object_Des_No_Blurs{scale,col},1)>0)
                    Tree = KDTreeSearcher(Object_Des_No_Blurs{scale,col});
                    
                    Idx = knnsearch(Tree,Test_Des_No_Blurs{scale,col}(i + test_point -1,:),'K',2);
                    
                    min_ssd_ind = Idx(1);
                    min_ssd_maybe = norm(Test_Des_No_Blurs{scale,col}(i + test_point -1,:)...
                        - Object_Des_No_Blurs{scale,col}(min_ssd_ind,:))^2;
                    
                    if (min_ssd_maybe < min_ssd)
                        good_point = i + test_point -1;
                        min_ssd = min_ssd_maybe;
                        Best_Idx = Idx;
                    end
                end
            end
            
            if (min_ssd < inf)
                % Will not always get two as there may only be one point
                % In Object_Des{blurs,scale}
                if (length(Best_Idx) > 1)
                    sec_min_ssd = norm(Test_Des_No_Blurs{scale,col}(good_point,:)...
                        - Object_Des_No_Blurs{scale,col}(Best_Idx(2),:))^2;
                    
                    % Should change threshold
                    if ((sec_min_ssd ==0) || (min_ssd/sec_min_ssd)>0.8)
                        test_point = test_point + end_point;
                        continue;
                    end
                end
                
                if (min_ssd > 100)
                    test_point = test_point + end_point;
                    continue;
                end
                
                x_object = Keypoints_Oriented_Object_No_Blurs{scale,col}(min_ssd_ind,1);
                y_object = Keypoints_Oriented_Object_No_Blurs{scale,col}(min_ssd_ind,2);
                x_in_test_image = ...
                    Keypoints_Oriented_Test_Image_No_Blurs{scale,col}(good_point,1);
                y_in_test_image = ...
                    Keypoints_Oriented_Test_Image_No_Blurs{scale,col}(good_point,2);
                
                Matched{scale,col}(good_point,:) = ...
                    [x_in_test_image,...
                    y_in_test_image,...
                    x_object,...
                    y_object,...
                    min_ssd];
                
                
            end
            test_point = test_point + end_point;
        end
    end
end
end


