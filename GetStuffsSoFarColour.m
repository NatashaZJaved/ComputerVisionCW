test_image = imread(strcat(pwd,'\dataset\Test\test_15.png'));
global sigma_0;
s = 3; n_subscales = 4; 
% Get the Lowes
[Lowes,BlurredImages] = LowesPyramid(test_image,sigma_0,s,n_subscales);

% Get them points
ThemPoints = Get_Keypoints_Colour(Lowes);

% Filter w/ Taylor
ReducedKeypoints = FilterWithTaylorNoSigmaColour(ThemPoints,Lowes,sigma_0,s);

% Filter w/ Hessian
ReducedReducedKeypoints = FilterWithHessianColour(ReducedKeypoints,Lowes,sigma_0,s);

% Orient
[Keypoints_Oriented,Magnitude,Orientations]...
    = AssignOrientationsColour(ReducedReducedKeypoints, BlurredImages, sigma_0,s);

% Get Descriptors
Descriptors = DescriptorsColour(Keypoints_Oriented,Magnitude,Orientations);