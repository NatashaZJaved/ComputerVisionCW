% We has test image
%Im_w_points = BlurredImages{1,scale};
Im_w_points = test_image;
% We find training image with most matches

% Bin image 011-trash
%trash = imread(strcat(pwd,'\dataset\Training\png\044-ferris-wheel.png'))
pic = 44;
% Define A

scale = 2;

Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));


train_image = imread(strcat(Directory,Files(pic).name));

Big_Boi = train_image;
if sum(size(train_image))~=sum(size(test_image))
    Big_Boi = [Big_Boi;zeros(size(test_image,1)-size(train_image,1),size(train_image,2),3)];
end
width_train = size(train_image,2);
Big_Boi = [Big_Boi,test_image];

imshow(Big_Boi);

count_lines = 0;
for col = 1:3
    
    
    where = find(~isnan(best_Match{scale,col,pic}(:,1)));
    disp(length(where))
    
    for i = 1:length(where)
        point = where(i);
        
        x_in_test = best_Match{scale,col,pic}(point,2);
        y_in_test = best_Match{scale,col,pic}(point,1);
        
        x_in_train = best_Match{scale,col,pic}(point,4);
        y_in_train = best_Match{scale,col,pic}(point,3);
        
        if (col == 1)
            color = 'red';
        elseif (col == 2)
            color = 'blue';
        else
            color = 'green';
        end
            
       
        
         Big_Boi = insertMarker(Big_Boi,[x_in_train y_in_train; ...
             x_in_test + width_train, y_in_test],'o','color',color,'size',3);
         
        count_lines = count_lines + 1;
        Match_Lines(count_lines,:) =[x_in_train, y_in_train,...
            x_in_test + width_train,y_in_test];
        
        line([x_in_train, x_in_test + width_train], [y_in_train,y_in_test])
        
    end
    
end


new_im = insertShape(Big_Boi,'Line',Match_Lines);
imshow(new_im);