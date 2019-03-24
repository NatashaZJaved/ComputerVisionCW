function Matches = intensity_based_matching(test_image)

%TRY WITH test_image = strcat(pwd,'\dataset\Test\test_1.png');

% [boxed, class_number]
Directory = strcat(pwd,'\Templates\');
Files = dir(strcat(pwd,'\Templates\*.mat'));

test_image = im2double(test_image);

% Normalise the test image
test_image(test_image<1e-8) = 0;

% Set Threshold
Threshold = 0.045;

Line_Mat = zeros(length(Files),10);
Matches = strings(length(Files),2);
count_lines = 0;
for k = 1:15*9*8
    Template = importdata(strcat(Directory,Files(k).name));
    %Template = importdata(strcat(Directory,'011-trash_rot_90_smaller_by_2_times.mat'));
    
    %Template = importdata(strcat(Directory,'011-trash_rot_90_smaller_by_2_times.mat'));
    %Template = importdata(strcat(Directory,'024-fountain_rot_315_smaller_by_4_times.mat'));
    %Template = importdata(strcat(Directory,'044-ferris-wheel_rot_270_smaller_by_3_times.mat'));
    %corr=zeros(size(test_image,1) + size(Template,1) - 1, ...
    %    size(test_image,2) + size(Template,2) - 1,3);
    corr = zeros(size(test_image));
    for i = 1:3
        %corr(:,:, = normxcorr2(Template(:,:,i),test_image(:,:,i));
        %corr(:,:,i) = filter2(Template(:,:,i), test_image(:,:,i))/norm(test_image(:,:,i));
        corr(:,:,i) = filter2(Template(:,:,i), test_image(:,:,i));
        corr(:,:,i) = corr(:,:,i)./norm(corr(:,:,i),'fro');
        %corr(:,:,i) = normxcorr2(Template(:,:,i),test_image(:,:,i));
    end
    
    summed_corr = sum(corr,3);
    Max = max(summed_corr(:));
    
    if Max > Threshold
        count_lines = count_lines +1;
        Matches(count_lines,:) = [Files(k).name, num2str(Max)];
       [xpeak, ypeak] = find(summed_corr==Max);

       xoffSet = ypeak;
       yoffSet = xpeak;
%         xoffSet = xpeak-size(Template,1);
%         yoffSet = ypeak-size(Template,2); 
        %[row, col] = find(summed_corr==Max);
        
        % DRAW BOX
        len = size(Template, 1); width = size(Template,2);
        
        str = strsplit(Files(k).name,'_');
        
        Theta = str2double(str{3});
        %Theta = 90;
        Rotate_Mat = [cosd(Theta),sind(Theta);-sind(Theta) cosd(Theta)];
        
        shift_len = ceil(len/2); shift_width = ceil(width/2);
        c1 = [-shift_len;-shift_width]; c2 = [shift_len;-shift_width];
        c3 = [-shift_len;shift_width]; c4 = [shift_len;shift_width];
        
        c1 = Rotate_Mat*c1 + [xoffSet; yoffSet];
        c2 = Rotate_Mat*c2 + [xoffSet; yoffSet];
        c3 = Rotate_Mat*c3 + [xoffSet; yoffSet];
        c4 = Rotate_Mat*c4 + [xoffSet; yoffSet];
        
        
        Line_Mat(count_lines,:) = [c1',c2',c4',c3',c1']; 
        line([c1(1),c2(1)],[c1(2),c2(2)]);
        line([c2(1),c4(1)],[c2(2),c4(2)]);
        line([c4(1),c3(1)],[c4(2),c3(2)]);
        line([c1(1),c3(1)],[c1(2),c3(2)]); 
    
    end
    
    disp(k);
    
end

Line_Mat = Line_Mat(1:count_lines,:);
Matches = Matches(1:count_lines,:);

new_im = insertShape(test_image,'Line',Line_Mat);
imshow(new_im);

end