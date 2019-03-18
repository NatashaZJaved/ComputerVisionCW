test_image = imread(strcat(pwd,'\dataset\Test\test_1.png'));
Im_Descript = GetDescriptorFromImage(test_image);

% Get the training images
Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));

Match = cell(length(Files),1);
count =  cell(length(Files),1);

disp(length(Files))
for k = 1:length(Files)
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    
    training_im_descript = GetDescriptorFromImage(Im);
    
    [Match{k}, count{k}] = Matching(Im_Descript, training_im_descript);
    
    disp(k)
end