warning ('off','all');
test_image = imread(strcat(pwd,'\dataset\Test\test_15.png'));
[Im_Descript, Keypoints] = GetDescriptorFromImageColour(test_image);

% Get the training images
Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));

n_images = 50;
Match = cell(length(Files)-n_images,1);
Test_Des_No_Blurs = cell(length(Files)-n_images,1);
Keypoints_Oriented_Test_Image_No_Blurs = cell(length(Files)-n_images,1);
Object_Des_No_Blurs = cell(length(Files)-n_images,1);
Keypoints_Oriented_Object_No_Blurs = cell(length(Files)-n_images,1);


for k = 1:n_images
    % Read images
    %Im = imread(strcat(Directory,Files(k).name));
    
    %[training_im_descript,train_points] = GetDescriptorFromImageColour(Im);
    
    tic;
    [Match{k}, Test_Des_No_Blurs, Keypoints_Oriented_Test_Image_No_Blurs,...
        Object_Des_No_Blurs{k}, Keypoints_Oriented_Object_No_Blurs{k}]...
        = Matching_PCAColoursNew(Im_Descript, ...
        Training_Im_Descripts{k}...
        ,Training_Points{k},...
        Keypoints);
    toc
    
    disp(k)
end


best_Match = CheckForBestestColoursNew(Match,Keypoints_Oriented_Test_Image_No_Blurs);

DrarMatches;