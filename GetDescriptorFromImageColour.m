function [Descript,Keypoints_Oriented] = GetDescriptorFromImageColour(Image)

sigma_0 = 0.5; s = 3; n_subscales = 4; 

% Get the Lowes
[Lowes,BlurredImages] = LowesPyramid(Image,sigma_0,s,n_subscales);

% Get them points
ThemPoints = Get_Keypoints_Colour(Lowes);

% Filter w/ Taylor
ReducedKeypoints = FilterWithTaylorNoSigmaColourNewFilter(ThemPoints,Lowes,sigma_0,s);

% Filter w/ Hessian
ReducedReducedKeypoints = FilterWithHessianColour(ReducedKeypoints,Lowes,sigma_0,s);

% Orient
[Keypoints_Oriented,Magnitude,Orientations]...
    = AssignOrientationsColour(ReducedReducedKeypoints, BlurredImages, sigma_0,s);

% Get Descriptors
Descript = DescriptorsColour(Keypoints_Oriented,Magnitude,Orientations);
end
