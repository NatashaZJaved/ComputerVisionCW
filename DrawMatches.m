% Clear lines
clear Match_Lines;

% Picture to compare
pic = 44;

% Scale to compare at
scale = 2;

% Load training image
Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));
train_image = imread(strcat(Directory,Files(pic).name));

% Stick test and training images together
Big_Boi = train_image;
if sum(size(train_image))~=sum(size(test_image))
    Big_Boi = [Big_Boi;zeros(size(test_image,1)-size(train_image,1),size(train_image,2),3)];
end
width_train = size(train_image,2);
Big_Boi = [Big_Boi,test_image];

% Draw lines between matches
count_lines = 0;
for col = 1:3
    
    
    where = find(~isnan(best_Match{scale,col,pic}(:,1)));
    disp(length(where))
    
    for i = 1:length(where)
        point = where(i);
        
        x_in_test = (2^(scale-1))*best_Match{scale,col,pic}(point,2);
        y_in_test = (2^(scale-1))*best_Match{scale,col,pic}(point,1);
        
        x_in_train = (2^(scale-1))*best_Match{scale,col,pic}(point,4);
        y_in_train = (2^(scale-1))*best_Match{scale,col,pic}(point,3);
        
        if (col == 1)
            color = 'red';
        elseif (col == 2)
            color = 'green';
        else
            color = 'blue';
        end
            
       
        
         Big_Boi = insertMarker(Big_Boi,[x_in_train y_in_train; ...
             x_in_test + width_train, y_in_test],'o','color',color,'size',3);
         
        count_lines = count_lines + 1;
        Match_Lines(count_lines,:) = [x_in_train, y_in_train,...
            x_in_test + width_train,y_in_test];
        
        line([x_in_train, x_in_test + width_train], [y_in_train,y_in_test])
        
    end
    
end


new_im = insertShape(Big_Boi,'Line',Match_Lines);
figure;
imshow(new_im);