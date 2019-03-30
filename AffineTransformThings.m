% We has test image
%Im_w_points = BlurredImages{1,scale};
Im_w_points = test_image;
% We find training image with most matches

% Bin image 011-trash
%trash = imread(strcat(pwd,'\dataset\Training\png\044-ferris-wheel.png'));
pic = 1;

% Define A

scale = 2;
count = 1;
A = zeros(2, 4);
b = zeros(2, 1);
for col = 1:3
    
    
    where = find(~isnan(best_Match{scale,col,pic}(:,1)));
    disp(length(where))
    %     if length(where) <= 3
    %         continue
    %     end
    
    
    for i = 1:length(where)
        point = where(i);
        
        A(2*count-1,:) = [best_Match{scale,col,pic}(point,3),...
            -best_Match{scale,col,pic}(point,4),1,0];
        A(2*count,:) = [best_Match{scale,col,pic}(point,4),...
            best_Match{scale,col,pic}(point,3),0,1];
        
        x = best_Match{scale,col,pic}(point,1);
        y = best_Match{scale,col,pic}(point,2);
        
        scaled_x = x*(2^(scale-1));
        scaled_y = y*(2^(scale-1));
        
        b(2*count-1) = scaled_x;
        b(2*count) = scaled_y;
        
        %         x = Match{pic}{scale,col}(point,1);
        %         y = Match{pic}{scale,col}(point,2);
        
        
        if (scaled_x>4 && scaled_x<(size(Im_w_points,1)-3) && ...
                scaled_y>4 && scaled_y<(size(Im_w_points,2)-3))
            Im_w_points((scaled_x-3):(scaled_x+3),(scaled_y-3):(scaled_y+3),col)...
                = Im_w_points((scaled_x-3):(scaled_x+3),(scaled_y-3):(scaled_y+3),col) + 255;
        end
        
        count = count + 1;
        
    end
    
    %imshow(Im_w_points);
end

Transform = A\b;
theta = asin(Transform(2)); a = Transform(1)/cos(theta);
tx = Transform(3); ty = Transform(4);

shift_len = ceil(size(test_image,1)/2);
shift_width = ceil(size(test_image,2)/2);
c1 = [-shift_len;-shift_width];c2 = [shift_len;-shift_width];
c3 = [-shift_len;shift_width];c4 = [shift_len;shift_width];


Transform = A\b;

T_mat = [Transform(1), -Transform(2); ...
    Transform(2), Transform(1)];
T_lation = [Transform(3)+shift_len;Transform(4)+shift_width];

c1 = (2^(scale-1))*(T_mat*c1 + T_lation);
c2 = (2^(scale-1))*(T_mat*c2 + T_lation);
c3 = (2^(scale-1))*(T_mat*c3 + T_lation);
c4 = (2^(scale-1))*(T_mat*c4 + T_lation);

imshow(Im_w_points);
hold on
line([c1(1),c2(1)],[c1(2),c2(2)]);
line([c2(1),c4(1)],[c2(2),c4(2)]);
line([c4(1),c3(1)],[c4(2),c3(2)]);
line([c1(1),c3(1)],[c1(2),c3(2)]);

disp(theta)
disp(a)
disp(c1)
%imshow(Im_w_points);
%
% for col = 1:3
%     for point = 1: size(Match{pic}{scale,col},1)
%         x = Match{pic}{scale,col}(point,1);
%         y = Match{pic}{scale,col}(point,2);
%         scaled_x = x*(2^(scale-1));
%         scaled_y = y*(2^(scale-1));
%
%         if (scaled_x>4 && scaled_x<(size(Im_w_points,1)-3) && ...
%                 scaled_y>4 && scaled_y<(size(Im_w_points,2)-3))
%             Im_w_points((scaled_x-3):(scaled_x+3),(scaled_y-3):(scaled_y+3),col)...
%                 = Im_w_points((scaled_x-3):(scaled_x+3),(scaled_y-3):(scaled_y+3),col) + 255;
%         end
%     end
% end
% imshow(Im_w_points);


