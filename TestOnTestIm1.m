global sigma_0;
sigma_0=5;

warning ('off','all');
test_image = imread(strcat(pwd,'\dataset\Test\test_15.png'));
[Im_Descript, Keypoints] = GetDescriptorFromImage(test_image);

% Get the training images
Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));

Match = cell(length(Files)-40,1);
count =  cell(length(Files)-40,1);

disp(length(Files))
for k = 1:length(Files)-40
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    
    [training_im_descript,train_points] = GetDescriptorFromImage(Im);
    
    tic;
    [Match{k}, count{k}] = Matching_PCA(Im_Descript, training_im_descript,train_points);
    toc
    
    disp(k)
end