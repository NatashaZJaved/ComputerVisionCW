function rectangles = intensity_based_matching(test_image)

%[boxed, class_number]
Directory = strcat(pwd,'\Templates\');
Files = dir(strcat(pwd,'\Templates\*.png'));

test_image = im2double(test_image);

%Normalise the test image
test_image(test_image<1e-8) = 0;

%Normalised correlation matrix
corr=zeros(size(test_image));

%CREATE RECTANGLE PLANE

rectangles = zeros(size(test_image,1),size(test_image,2));

for k = 1:length(Files)
    Template = imread(strcat(Directory,Files(k).name));
    %Template = imread(strcat(Directory,'011-trash_rot_90_smaller_by_4_times.png'));
    for i = 1:3 
        %corr(:,:, = normxcorr2(Template(:,:,i),test_image(:,:,i));
        %corr(:,:,i) = filter2(Template(:,:,i), test_image(:,:,i))/norm(test_image(:,:,i));
        corr(:,:,i) = filter2(Template(:,:,i), test_image(:,:,i))/norm(filter2(Template(:,:,i), test_image(:,:,i)));
    end
    
    
    
    Threshold = 0.032;
    summed_corr = sum(corr,3);
    Max = max(summed_corr(:));
    
    
    
    if Max > Threshold
        
    
        [row col] = find(summed_corr==Max);
        
        corr(row-2:row+2, col-2:col+2) = 1;
        
        % DRAW BOX
        origin = [row col];
        len = size(Template, 1); width = size(Template,2);

        rectangles_orig = ones(len, width);
        %REMOVE CENTRE OF BOX
        rectangles_orig(5:len-5, 5:width-5)=0;
        
       
        %ROTATE BOX
        str = strsplit(Files(k).name,'_');
        %str = strsplit('011-trash_rot_90_smaller_by_4_times.png','_');
        rectangles_orig = imrotate(rectangles_orig,str2num(str{3}));
        
        %ADD BOX TO THE IMAGE OF RECTANGLES
        
        min_length = max(row-floor(size(rectangles_orig,1)/2),1);
        max_length = min(row+floor(size(rectangles_orig,1)/2)-1, size(rectangles,1));
        min_width = max(col-floor(size(rectangles_orig,2)/2), 1);
        max_width = min(col+floor(size(rectangles_orig,2)/2)-1, size(rectangles,2));
        
        if max_length == size(rectangles,1)
            rectangles_orig = rectangles_orig(1:size(rectangles,1)-row,:);
        end
        if min_length == 1
            rectangles_orig = rectangles_orig(1:row - size(rectangles,1),:);
        end   
        if max_width == size(rectangles,2)
            rectangles_orig = rectangles_orig(:,1:size(rectangles,2) - col);
        end        
        if min_width == 1
            rectangles_orig = rectangles_orig(:,1:col - size(rectangles,2));
        end                
        
        
        rectangles(min_length:max_length,...
            min_width:max_width) = rectangles(min_length:max_length,min_width:max_width) + rectangles_orig;
        
        rectangles(rectangles>0) = 1;

        
        %Locates centre of highest intensity
        %rectangles(row-2:row+2, col-2:col+2) = 1;

    end
    
    disp(k);
    
end

