% We has test image test_image
warning('on')
Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));
imshow(test_image,[]);
hold on
% eps for ransac
eps = 20;
scale = 1;
for train_pic = 1:10%length(Files)
    curr_train = imread(strcat(Directory,Files(train_pic).name));
    
    for col = 1:3
        best_inliers = []; best_transform = zeros(4,1);
        best_Match{scale,col,train_pic} = unique(best_Match{scale,col,train_pic}, 'rows');
        %If we have less than 4 points (so can't do RANSAC), don't include
        %match
        where = find(best_Match{scale,col,train_pic}(:,1));
        if length(where) <= 3
            continue
        end
        
        for num_ran = 1:14
            %RANSAC
            int_sample = datasample(where,4,'Replace',false);
            
            % Define A and b
            A = zeros(2*size(int_sample,2), 4);
            b = zeros(2*size(int_sample,2), 1);
            
            for j = 1:length(int_sample)
                point = int_sample(j);
                
                
                %Allocate A
                A(2*j-1,:) = [best_Match{scale,col,train_pic}(point,3),...
                    -best_Match{scale,col,train_pic}(point,4),1,0];
                A(2*j,:) = [best_Match{scale,col,train_pic}(point,3),...
                    best_Match{scale,col,train_pic}(point,4),0,1];
                
                %Find test image keypoint coordinates
                %Allocate b
                b(2*j-1) = best_Match{scale,col,train_pic}(point,1);
                b(2*j) = best_Match{scale,col,train_pic}(point,2);
                
            end
            
            Transform = A\b;
            %         theta = asin(Transform(2)); a = Transform(1)/cos(theta);
            %         tx = Transform(3); ty = Transform(4);
            
            T_mat = [Transform(1), -Transform(2); ...
                Transform(2), Transform(1)];
            T_lation = [Transform(3);Transform(4)];
            
            
            % Check for in/outliers
            curr_inliers = [];
            %blur = 1;
            for point = 1:length(best_Match{scale,col,train_pic})
                
                Transformed = T_mat*...
                    (best_Match{scale,col,train_pic}(point,3:4)') + T_lation;
                Actual =  best_Match{scale,col,train_pic}(point,1:2)';
                
                % Check difference
                if norm(Transformed - Actual) < eps
                    curr_inliers = [curr_inliers;point];
                end
                
            end
            if (length(curr_inliers)>length(best_inliers))
                best_inliers = curr_inliers;
                best_transform = Transform;
            end
        end
        
        the_inliers = best_Match{scale,col,train_pic}(best_inliers,3:4);
        
        if (size(the_inliers,1) >=3)
            
            % RERUN AFFINE TRANSFORM WITH ALL THE GOOD POINTS
            A = zeros(2*size(the_inliers,1), 4);
            b = zeros(2*size(the_inliers,1), 1);
            %blur = 1;
            for j = 1:size(the_inliers,1)
                point = the_inliers(j,:);
                A(2*j-1,:) = [point(1),-point(2),1,0];
                A(2*j,:) = [point(2),point(1),0,1];
                
                b(2*j-1) = best_Match{scale,col,train_pic}(best_inliers(j),1);
                b(2*j) = best_Match{scale,col,train_pic}(best_inliers(j),1);
            end
            
            % Corners of rectangle
            shift_len = ceil(size(curr_train,1)/2);
            shift_width = ceil(size(curr_train,2)/2);
            
            c1 = [-shift_len;-shift_width];c2 = [shift_len;-shift_width];
            c3 = [-shift_len;shift_width];c4 = [shift_len;shift_width];
            
            
            Transform = A\b;

            T_mat = [Transform(1), -Transform(2); ...
                Transform(2), Transform(1)];
            T_lation = [Transform(3)+shift_len;Transform(4)+shift_width];
            
            c1 = T_mat*c1 + T_lation;
            c2 = T_mat*c2 + T_lation;
            c3 = T_mat*c3 + T_lation;
            c4 = T_mat*c4 + T_lation;
            
            line([c1(1),c2(1)],[c1(2),c2(2)]);
            line([c2(1),c4(1)],[c2(2),c4(2)]);
            line([c4(1),c3(1)],[c4(2),c3(2)]);
            line([c1(1),c3(1)],[c1(2),c3(2)]);
        end
    end
    
end

hold off