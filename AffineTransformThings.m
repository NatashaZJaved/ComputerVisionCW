% We has test image
scale = 1;
%Im_w_points = BlurredImages{1,scale};
Im_w_points = test_image;
% We find training image with most matches

% Bin image 011-trash
trash = imread(strcat(pwd,'\dataset\Training\png\044-ferris-wheel.png'));
num = 44;



selec = [];
blur_vec = [];
for blurs = 1:size(best_Match,1)
   %Select all of the matches relating to bin and store them together
   f = find(best_Match{blurs,scale}(:,1) == num);
   selec = [selec; best_Match{blurs,scale}(f,:)];
   if length(f)>0
      blur_vec(end + 1) = length(f);
   else
       blur_vec(end + 1) = 0;
   end
end

% Now lets do affine transform on the sellc

% Define A 
A = zeros(2*size(selec,1), 4);
b = zeros(2*size(selec,1), 1);
blur = 1;
for point = 1:size(selec,1)
    A(2*point-1,:) = [selec(point,2),-selec(point,3),1,0];
    A(2*point,:) = [selec(point,3),-selec(point,2),0,1];
    
    x = Keypoints{blur,scale}(point,1);
    y = Keypoints{blur,scale}(point,2);
    b(2*point-1) = Keypoints{blur,scale}(point,1);
    b(2*point) = Keypoints{blur,scale}(point,2);
    
    Im_w_points(x-3:x+3,y-3:y+3) = Im_w_points(x-3:x+3,y-3:y+3) + 100;
       
    
    
    if point > sum(blur_vec(1:blur))
        blur = blur + 1;
    end
    
end

Transform = A\b;
theta = asin(Transform(2)); a = Transform(1)/cos(theta);
tx = Transform(3); ty = Transform(4);

imshow(Im_w_points);
