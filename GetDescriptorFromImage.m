function [Descript,Keypoints_Oriented] = GetDescriptorFromImage(Image)

s = 3; n_subscales = 4; sigma_0 = 0.2;

% Get the Lowes
[Lowes,BlurredImages] = LowesPyramid(Image,sigma_0,s,n_subscales);

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
Descript = Descriptors(Keypoints_Oriented,Magnitude,Orientations);
end
