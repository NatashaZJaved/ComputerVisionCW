test_image = imread(strcat(pwd,'\dataset\Test\test_1.png'));
s = 3; n_subscales = 4; sigma_0 = 0.2;
% Get the Lowes
[Lowes,BlurredImages] = LowesPyramid(test_image,sigma_0,s,n_subscales);

% Get them points
ThemPoints = Keypoints(Lowes);

% Filter w/ Taylor
ReducedKeypoints = FilterWithTaylor(ThemPoints,Lowes,sigma_0,s);

% Filter w/ Hessian
ReducedReducedKeypoints = FilterWithHessian(ReducedKeypoints,Lowes,sigma_0,s);

% Orient
Keypoints_Oriented = AssignOrientations(ReducedReducedKeypoints, BlurredImages, sigma_0,s);