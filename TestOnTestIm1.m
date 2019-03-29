warning ('off','all');
test_image = imread(strcat(pwd,'\dataset\Test\test_1.png'));
[Im_Descript, Keypoints] = GetDescriptorFromImageColour(test_image);

% Get the training images
Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));

Match = cell(length(Files)-40,1);
Test_Des_No_Blurs = cell(length(Files)-40,1);
Keypoints_Oriented_Test_Image_No_Blurs = cell(length(Files)-40,1);
Object_Des_No_Blurs = cell(length(Files)-40,1);
Keypoints_Oriented_Object_No_Blurs = cell(length(Files)-40,1);

disp(length(Files))
for k = 1:length(Files)-40
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    
    [training_im_descript,train_points] = GetDescriptorFromImageColour(Im);
    
    tic;
    [Match{k}, Test_Des_No_Blurs, Keypoints_Oriented_Test_Image_No_Blurs,...
        Object_Des_No_Blurs{k}, Keypoints_Oriented_Object_No_Blurs{k}]...
        = Matching_PCAColoursNew(Im_Descript, training_im_descript,train_points, Keypoints);
    toc
    
    disp(k)
end