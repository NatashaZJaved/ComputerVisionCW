function [Matches,Line_Mat] = intensity_based_matching(test_image,Thresholds_init, Thresholds)

Directory = strcat(pwd,'\Templates\');
Files = dir(strcat(pwd,'\Templates\*.mat'));

test_image = im2double(test_image);

% Remove background from the test image
test_image(test_image<1e-8) = 0;

Line_Mat = zeros(length(Files),10);
Corners = zeros(length(Files),4);
Area = zeros(length(Files));
Corr = zeros(length(Files));
Matches = strings(length(Files),2);

count_lines = 0;

pictures = Getpicturenames;

rotations = [0,180,90,270,30,60,120,150,210,240,270,300,330]';

scales = [2,3,4,8,12,16]';

for pic = 1:length(pictures)
    
    pass_pic = false;
    
    if (pic == 28) 
        continue;
    end
    
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
                 
                len = size(Template, 1); width = size(Template,2);
                
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

Area = Area(1:count_lines);
Corners = Corners(1:count_lines,:);
Corr = Corr(1:count_lines);

% Perform Non-Maxima Suppression
overlap_thresh = 0.1;
Selected = ibm_non_max_sup(Corners, Corr, overlap_thresh, Area);

Corners=Corners(Selected,:);
positions = Corners(:,2:3);

Line_Mat = Line_Mat(Selected,:);
Matches = Matches(Selected,:);

% Add Lines and text to matches
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