% We has test image
scale = 1;
%Im_w_points = BlurredImages{1,scale};
Im_w_points = test_image;
% We find training image with most matches

% Bin image 011-trash
%trash = imread(strcat(pwd,'\dataset\Training\png\044-ferris-wheel.png'));
pic = 8;

% Define A

scale = 4;
for col = 1:3
    A = zeros(2*size(best_Match{scale,col,pic},1), 4);
    b = zeros(2*size(best_Match{scale,col,pic},1), 1);
    
    where = find(best_Match{scale,col,pic}(:,1));
    disp(length(where))
    %     if length(where) <= 3
    %         continue
    %     end
    
    for i = 1:length(where)
        point = where(i);
        
        A(2*point-1,:) = [best_Match{scale,col,pic}(point,3),...
            -best_Match{scale,col,pic}(point,4),1,0];
        A(2*point,:) = [best_Match{scale,col,pic}(point,3),...
            best_Match{scale,col,pic}(point,4),0,1];
        
        x = best_Match{scale,col,pic}(point,1);
        y = best_Match{scale,col,pic}(point,2);
        
        b(2*point-1) = x;
        b(2*point) = y;
        
        x = Match{pic}{scale,col}(point,1);
        y = Match{pic}{scale,col}(point,2);
        scaled_x = x*(2^(scale-1));
        scaled_y = y*(2^(scale-1));
        
        if (x>4 && x<size(Im_w_points,1) && ...
                y>4 && y<size(Im_w_points,2))
            Im_w_points(scaled_x-3:scaled_x+3,scaled_y-3:scaled_y+3,col)...
                = Im_w_points(scaled_x-3:scaled_x+3,scaled_y-3:scaled_y+3,col) + 255;
        end
        
    end
    Transform = A\b;
    theta = asin(Transform(2)); a = Transform(1)/cos(theta);
    tx = Transform(3); ty = Transform(4);
    
    %imshow(Im_w_points);
end
imshow(Im_w_points);
% 
for col = 1:3
    for point = 1: size(Match{pic}{scale,col},1)
        x = Match{pic}{scale,col}(point,1);
        y = Match{pic}{scale,col}(point,2);
        scaled_x = x*(2^(scale-1));
        scaled_y = y*(2^(scale-1));
        
        if (x>4 && x<size(Im_w_points,1) && ...
                y>4 && y<size(Im_w_points,2))
            Im_w_points(scaled_x-3:scaled_x+3,scaled_y-3:scaled_y+3,col)...
                = Im_w_points(scaled_x-3:scaled_x+3,scaled_y-3:scaled_y+3,col) + 255;
        end
    end
end
imshow(Im_w_points);


