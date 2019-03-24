test_image = imread(strcat(pwd,'\dataset\Test\test_15.png'));
global sigma_0;
s = 3; n_subscales = 4; 
% Get the Lowes
[Lowes,BlurredImages] = LowesPyramid(test_image,sigma_0,s,n_subscales);

% Get them points
ThemPoints = Get_Keypoints(Lowes);

% Filter w/ Taylor
ReducedKeypoints = FilterWithTaylor(ThemPoints,Lowes,sigma_0,s);

% Filter w/ Hessian
ReducedReducedKeypoints = FilterWithHessian(ReducedKeypoints,Lowes,sigma_0,s);

% Orient
[Keypoints_Oriented,Magnitude,Orientations]...
    = AssignOrientations(ReducedReducedKeypoints, BlurredImages, sigma_0,s);

% Get Descriptors
Descriptors = Descriptors(Keypoints_Oriented,Magnitude,Orientations);