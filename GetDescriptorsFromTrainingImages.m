warning ('off','all');

Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));

n_images = 3;
Training_Im_Descripts = cell(n_images,1);
Training_Points = cell(n_images,1);

for k = 1:n_images
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    
    [Training_Im_Descripts{k},Training_Points{k}] = ...
        GetDescriptorFromImageColour(Im);
end