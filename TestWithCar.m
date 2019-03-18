test_image = imread(strcat(pwd,'\dataset\Test\test_1.png'));
the_car = imread(strcat(pwd,'\dataset\training\png\022-car.png'));
s = 3; n_subscales = 4; sigma_0 = 0.2;

Ims = cell(2,1);
Ims{1} = test_image; Ims{2} = the_car;

for i = 1:2
    % Get the Lowes
    [Lowes,BlurredImages] = LowesPyramid(Ims{i},sigma_0,s,n_subscales);
    
    % Get them points
    ThemPoints = Keypoints(Lowes);
    
    % Filter w/ Taylor
    ReducedKeypoints = FilterWithTaylor(ThemPoints,Lowes,sigma_0,s);
    
    % Filter w/ Hessian
    ReducedReducedKeypoints = FilterWithHessian(ReducedKeypoints,Lowes,sigma_0,s);
    
    % Orient
    [Keypoints_Oriented,Magnitude,Orientations]...
        = AssignOrientations(ReducedReducedKeypoints, BlurredImages, sigma_0,s);
    
    % Get Descriptors
    if (i == 1)
        Im_descript = Descriptors(Keypoints_Oriented,Magnitude,Orientations);
    else
        Car_descript = Descriptors(Keypoints_Oriented,Magnitude,Orientations);
    end
end

[Matched,count] = Matching(Im_descript, Car_descript);