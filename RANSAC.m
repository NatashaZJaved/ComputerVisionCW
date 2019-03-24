% We has test image test_image
warning('on')
Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));
imshow(test_image,[]);
hold on
% eps for ransac
eps = 20;
scale = 1;
for train_pic = 1:length(Files)
    curr_train = imread(strcat(Directory,Files(train_pic).name));
    
    match_points_in_train = [];
    blurs_loc=[];
    for blurs = 1:size(best_Match,1)
        %Select all of the matches relating to bin and store them together
        f = find(best_Match{blurs,scale}(:,1) == train_pic);
        match_points_in_train = [match_points_in_train; best_Match{blurs,scale}(f,:),f];
        appended = ones(size(f,1),1)*blurs;
        blurs_loc = [blurs_loc;appended];
    end
     
    [get_unique,ia,ic] = unique(match_points_in_train(:,2:3),'rows'); 
    blurs_loc =  blurs_loc(ia);
    key_loc = match_points_in_train(ia,5);
    match_points_in_train = get_unique;
    
    [blurs_loc,indices] = sort(blurs_loc);
    match_points_in_train = match_points_in_train(indices,:);
    key_loc = key_loc(indices);
    
    
    blur_vec = zeros(size(best_Match,1),1);
    for i = 1:length(blur_vec)
        blur_vec(i) = sum(blurs_loc==i);
    end
    
    best_inliers = []; best_transform = zeros(4,1);
    
    %If we have less than 4 points (so can't do RANSAC), don't include
    %match
    if size(match_points_in_train,1) <= 3
        continue
    end
    
    for num_ran = 1:14
        %RANSAC
        int_vec = 1:size(match_points_in_train,1);
        int_sample = datasample(int_vec,4,'Replace',false);
        
        % Define A and b
        A = zeros(2*size(int_sample,2), 4);
        b = zeros(2*size(int_sample,2), 1);

        for j = 1:size(int_sample,2)
            point = int_sample(j);
            
            %Find correct blur 
            where_bigger = find(point<=cumsum(blur_vec));
            %Select first one where point<=cumsum(blur_vec), to get correct
            %blur
            blur = where_bigger(1);
            
            %Allocate A 
            A(2*j-1,:) = [match_points_in_train(point,1),-match_points_in_train(point,2),1,0];
            A(2*j,:) = [match_points_in_train(point,2),match_points_in_train(point,1),0,1];
            
            %Find test image keypoint coordinates
            Keypoint_Location = key_loc(point);
            %x = Keypoints{blur,scale}(Keypoint_Location,1);
            %y = Keypoints{blur,scale}(Keypoint_Location,2);
            
            %Allocate b
            b(2*j-1) = Keypoints{blur,scale}(Keypoint_Location,1);
            b(2*j) = Keypoints{blur,scale}(Keypoint_Location,2);
            
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
        for point = 1:length(match_points_in_train)
            where_bigger = find(point<=cumsum(blur_vec));
            blur = where_bigger(1);
            Keypoint_Location = key_loc(point);
            
            Transformed = T_mat*...
                (match_points_in_train(point,:)') + T_lation;
            Actual =  Keypoints{blur,scale}(Keypoint_Location,1:2)';
            
            % Check difference
            if norm(Transformed - Actual) < eps
                curr_inliers = [curr_inliers;point];
            end
            
            %if point > sum(blur_vec(1:blur))
            %    blur = blur + 1;
            %end
        end
        if (length(curr_inliers)>length(best_inliers))
            best_inliers = curr_inliers;
            best_transform = Transform;
        end
    end
    
    the_inliers = match_points_in_train(best_inliers,:);
    
    
    if (size(the_inliers,1) >=3)
        
        % RERUN AFFINE TRANSFORM WITH ALL THE GOOD POINTS
        A = zeros(2*size(the_inliers,1), 4);
        b = zeros(2*size(the_inliers,1), 1);
        %blur = 1;
        for j = 1:size(the_inliers,1)
            point = the_inliers(j,:);
            where_bigger = find(best_inliers(j)<=cumsum(blur_vec));
            blur = where_bigger(1);
            A(2*j-1,:) = [point(1),-point(2),1,0];
            A(2*j,:) = [point(2),point(1),0,1];
            
            Keypoint_Location = key_loc(best_inliers(j));
            x = Keypoints{blur,scale}(Keypoint_Location,1);
            y = Keypoints{blur,scale}(Keypoint_Location,2);
            b(2*j-1) = Keypoints{blur,scale}(Keypoint_Location,1);
            b(2*j) = Keypoints{blur,scale}(Keypoint_Location,2);
            
            
            %if point > sum(blur_vec(1:blur))
            %    blur = blur + 1;
            %end
            
            
        end
%         
        % Corners of rectangle
        shift_len = ceil(size(curr_train,1)/2);
        shift_width = ceil(size(curr_train,2)/2);
        %c1 = [1;1]; c2 = [size(curr_train,1);1];
        %c3 = [1;size(curr_train,2)]; c4 = [size(curr_train,1);size(curr_train,2)];
        
        c1 = [-shift_len;-shift_width];c2 = [shift_len;-shift_width];
        c3 = [-shift_len;shift_width];c4 = [shift_len;shift_width];
        
        
%         T_mat = [best_transform(1), -best_transform(2); ...
%             best_transform(2), best_transform(1)];
%         T_lation = [best_transform(3);best_transform(4)];
        Transform = A\b;
        %         theta = asin(Transform(2)); a = Transform(1)/cos(theta);
        %         tx = Transform(3); ty = Transform(4);
        
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

hold off