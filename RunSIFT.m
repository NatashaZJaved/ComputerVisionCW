warning ('off','all');
tic;

load Training.mat

% Input test image
test_image = imread(strcat(pwd,'\dataset\Test\test_15.png'));
% Get keypoints and descriptors
[Im_Descript, Keypoints] = GetDescriptorFromImage(test_image);

n_images = 50;
Match = cell(n_images,1);
Test_Des_No_Blurs = cell(n_images,1);
Keypoints_Oriented_Test_Image_No_Blurs = cell(n_images,1);
Object_Des_No_Blurs = cell(n_images,1);
Keypoints_Oriented_Object_No_Blurs = cell(n_images,1);

% Matching

for k = 1:n_images
    
    [Match{k}, Test_Des_No_Blurs, Keypoints_Oriented_Test_Image_No_Blurs,...
        Object_Des_No_Blurs{k}, Keypoints_Oriented_Object_No_Blurs{k}]...
        = Matching(Im_Descript, ...
        Training_Im_Descripts{k}...
        ,Training_Points{k},...
        Keypoints);
    
    disp(k)
end

% Get best matches
best_Match = CheckForBestest(Match,Keypoints_Oriented_Test_Image_No_Blurs);
toc
DrawMatches;