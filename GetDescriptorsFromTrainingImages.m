warning ('off','all');

Directory = strcat(pwd,'\dataset\Training\png\');
Files = dir(strcat(Directory,'*.png'));

Training_Im_Descripts = cell(length(Files),1);
Training_Points = cell(length(Files),1);

for k = 1:length(Files)
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    
    [Training_Im_Descripts{k},Training_Points{k}] = ...
        GetDescriptorFromImageColour(Im);
end