% We has test image
%Im_w_points = BlurredImages{1,scale};
Im_w_points = test_image;
% We find training image with most matches

% Bin image 011-trash
%trash = imread(strcat(pwd,'\dataset\Training\png\044-ferris-wheel.png'))
pic = 1;
% Define A

scale = 1;

Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));


train_image = imread(strcat(Directory,Files(pic).name));

Big_Boi = train_image;
if size(train_image)~=size(test_image)
    Big_Boi = [Big_Boi;zeros(size(test_image,1)-size(train_image,1),size(test_image,2))];
end
width_train = size(train_image,2);
Big_Boi = [Big_Boi,test_image];

imshow(Big_Boi);

for col = 1:3
    
    
    where = find(~isnan(best_Match{scale,col,pic}(:,1)));
    disp(length(where))
    
    for i = 1:length(where)
        point = where(i);
        
        x_in_test = best_Match{scale,col,pic}(point,2);
        y_in_test = best_Match{scale,col,pic}(point,1);
        
        x_in_train = best_Match{scale,col,pic}(point,4);
        y_in_train = best_Match{scale,col,pic}(point,3);
        
        
        
%         Big_Boi = insertMarker(Big_Boi,[x_in_train y_in_train; ...
%             x_in_test + width_train, y_in_test]);
%         
%         imshow(Big_Boi);
        
        line([x_in_train, x_in_test + width_train], [y_in_train,y_in_test])
        
        
    end
    
    %imshow(Im_w_points);
end


