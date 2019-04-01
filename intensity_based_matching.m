function [Matches,Line_Mat,Corners,Area,Corr] = intensity_based_matching(test_image,Thresholds_init, Thresholds)

%TRY WITH test_image = strcat(pwd,'\dataset\Test\test_1.png');

% [boxed, class_number]
Directory = strcat(pwd,'\Templates\');
Files = dir(strcat(pwd,'\Templates\*.mat'));

test_image = im2double(test_image);

% Normalise the test image
test_image(test_image<1e-8) = 0;

% Set Threshold
%Min_Threshold = Threshold(1);

Line_Mat = zeros(length(Files),10);
Corners = zeros(length(Files),4);
Area = zeros(length(Files));
Corr = zeros(length(Files));
Matches = strings(length(Files),2);

count_lines = 0;

pictures = Getpicturenames;

%rotations = [0,180,90,270, 22.5,45,67.5,112.5,135,157.5,202.5,225,247.5,292.5,315,337.5]';
rotations = [0,180,90,270,30,60,120,150,210,240,270,300,330]';

%scales = [2,3,4,8,12,16]';
scales = [2,3,4,8,12,16]';

for pic = 1:length(pictures)
    
    if (pic == 28)
        continue;
    end
    pass_pic = false;
    for rotate_ind = 1:length(rotations)
        rotate = rotations(rotate_ind);
        if (rotate == 30) && ~(pass_pic)
            break;
        end

        for scale_ind = 1:length(scales)
            
            scale = scales(scale_ind);
            
            Initial_Threshold = Thresholds_init(scale);
            
            filename = strcat(pictures(pic),'_smaller_by_',num2str(scale),...
                '_times_rot_',num2str(rotate),'.mat');
            Template = importdata(strcat(Directory,filename));
            
            corr = zeros(size(test_image));
            for i = 1:3
                corr(:,:,i) = filter2(Template(:,:,i), test_image(:,:,i));
            end
            
            summed_corr = sum(corr,3);
            Max = max(summed_corr(:));
            
            if Max > Initial_Threshold
                pass_pic = true;
            end
            
            Proper_Threshold = Thresholds(scale);
            
            if Max > Proper_Threshold
                
                count_lines = count_lines +1;
                Matches(count_lines,:) = [pictures(pic), string(Max)];
                [xpeak, ypeak] = find(summed_corr==Max);
                
                xoffSet = ypeak;
                yoffSet = xpeak;
                
                % DRAW BOX
                len = size(Template, 1); width = size(Template,2);
                
                %Theta = 90;
                Rotate_Mat = [cosd(rotate),sind(rotate);-sind(rotate) cosd(rotate)];
                
                shift_len = ceil(len/2); shift_width = ceil(width/2);
                c1 = [-shift_len;-shift_width]; c2 = [shift_len;-shift_width];
                c3 = [-shift_len;shift_width]; c4 = [shift_len;shift_width];
                
                Corners(count_lines,:) = [c1(1) + xoffSet, c2(1) + xoffSet, ...
                    c1(2) + yoffSet, c3(2) + yoffSet];
                Area(count_lines) = len*width;
                Corr(count_lines) = Max;
                
                c1 = Rotate_Mat*c1 + [xoffSet; yoffSet];
                c2 = Rotate_Mat*c2 + [xoffSet; yoffSet];
                c3 = Rotate_Mat*c3 + [xoffSet; yoffSet];
                c4 = Rotate_Mat*c4 + [xoffSet; yoffSet];
                
                
                Line_Mat(count_lines,:) = [c1',c2',c4',c3',c1'];
            end
            
        end
    end
    disp(pictures(pic))
end



% for k = 1:length(Files)
%     Template = importdata(strcat(Directory,Files(k).name));
%     
%     str = strsplit(Files(k).name,'_');
%     str_name = strsplit(Files(k).name,'-');
%     Theta_str_split = strsplit(str{7},'.');
%     
%     
%     curr_pic = str2double(str_name{1});
%     curr_rotation = str2double(Theta_str_split{1});
%     
%     scale = str2double(str{4});
%     Initial_Threshold = Thresholds_init(scale);
%     
%     corr = zeros(size(test_image));
%     
%     if (curr_rotation == last_rotation + 90)
%         % Reset everything
%         count_pic = 0;
%         pass_pic = false;
%         forget_this_guy = false;
%         last_rotation = curr_rotation;
%     end
%     
%     % THIS BIT FOR FORGETTING PICTURE IF IT FAILS A LOT
%     if (last_pic == curr_pic)
%         count_pic = count_pic + 1;
%     else
%         % reset pass_pic and forget_this_guy
%         pass_pic = false;
%         forget_this_guy = false;
%         count_pic = 0;
%         last_rotation = 0;
%     end
%     
%     if (count_pic > 10 && ~(pass_pic))
%         % This picture has failed
%         forget_this_guy = true;
%     end
%     
%     if (forget_this_guy)
%         continue;
%     end
%     % END
%     
%     for i = 1:3
%         corr(:,:,i) = filter2(Template(:,:,i), test_image(:,:,i));
%     end
%     
%     summed_corr = sum(corr,3);
%     Max = max(summed_corr(:));
%     
%     if Max > Initial_Threshold
%         pass_pic = true;
%     end
%     
%     Proper_Threshold = Thresholds(scale);
%     
%     if Max > Proper_Threshold
%         
%         count_lines = count_lines +1;
%         Matches(count_lines,:) = [Files(k).name, string(Max)];
%         [xpeak, ypeak] = find(summed_corr==Max);
%         
%         xoffSet = ypeak;
%         yoffSet = xpeak;
%         %         xoffSet = xpeak-size(Template,1);
%         %         yoffSet = ypeak-size(Template,2);
%         %[row, col] = find(summed_corr==Max);
%         
%         % DRAW BOX
%         len = size(Template, 1); width = size(Template,2);
%         
%         %str = strsplit(Files(k).name,'_');
%         
%         Theta_str_split = strsplit(str{7},'.');
%         Theta = str2double(Theta_str_split{1});
%         %Theta = 90;
%         Rotate_Mat = [cosd(Theta),sind(Theta);-sind(Theta) cosd(Theta)];
%         
%         shift_len = ceil(len/2); shift_width = ceil(width/2);
%         c1 = [-shift_len;-shift_width]; c2 = [shift_len;-shift_width];
%         c3 = [-shift_len;shift_width]; c4 = [shift_len;shift_width];
%         
%         Corners(count_lines,:) = [c1(1) + xoffSet, c2(1) + xoffSet, ...
%             c1(2) + yoffSet, c3(2) + yoffSet];
%         Area(count_lines) = len*width;
%         Corr(count_lines) = Max;
%         
%         c1 = Rotate_Mat*c1 + [xoffSet; yoffSet];
%         c2 = Rotate_Mat*c2 + [xoffSet; yoffSet];
%         c3 = Rotate_Mat*c3 + [xoffSet; yoffSet];
%         c4 = Rotate_Mat*c4 + [xoffSet; yoffSet];
%         
%         
%         Line_Mat(count_lines,:) = [c1',c2',c4',c3',c1'];
%     end
%     
%     disp(k);
%     
%     last_pic = curr_pic;
% end

Area = Area(1:count_lines);
Corners = Corners(1:count_lines,:);
Corr = Corr(1:count_lines);

overlap_thresh = 0.1;
Selected = ibm_non_max_sup(Corners, Corr, overlap_thresh, Area);

Corners=Corners(Selected,:);
positions = Corners(:,2:3);

Line_Mat = Line_Mat(Selected,:);
Matches = Matches(Selected,:);


Match_split=strings(size(Matches,1),1);
for boxx=1:size(Matches,1)
    splitter = split(Matches(boxx,1),'_');
    Match_split(boxx,1)=splitter(1);
end
str_match = cellstr(Match_split);

new_im = insertShape(test_image,'Line',Line_Mat);
new_im=insertText(new_im,positions,str_match,'FontSize',11);
imshow(new_im);

end