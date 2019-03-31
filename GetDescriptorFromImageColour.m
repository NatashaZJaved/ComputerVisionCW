function [Descript,Keypoints_Oriented,...
    Drawing_Initial,Drawing_After_Taylor,Drawing_After_Hessian,...
    Boxes, Boxes_Orient] = GetDescriptorFromImageColour(Image)

sigma_0 = 0.5; s = 3; n_subscales = 4; 

% Get the Lowes
[Lowes,BlurredImages] = LowesPyramid(Image,sigma_0,s,n_subscales);

% Get them points
ThemPoints = Get_Keypoints_Colour(Lowes);

%DrawKeypoints(ThemPoints,Image);
%pause;
Drawing_Initial = DrawKeypoints(ThemPoints,Image);

% Filter w/ Taylor
ReducedKeypoints = FilterWithTaylorNoSigmaColourNewFilter(ThemPoints,Lowes,sigma_0,s);

Drawing_After_Taylor = DrawKeypoints(ReducedKeypoints,Image);
%pause;


% Filter w/ Hessian
ReducedReducedKeypoints = FilterWithHessianColour(ReducedKeypoints,Lowes,sigma_0,s);

Drawing_After_Hessian = DrawKeypoints(ReducedReducedKeypoints,Image);

Boxes = DrawBoxes(ReducedReducedKeypoints,Image);
%pause;
%DrawBoxes(ReducedReducedKeypoints,Image);
%pause;

% Orient
[Keypoints_Oriented,Magnitude,Orientations]...
    = AssignOrientationsColour(ReducedReducedKeypoints, BlurredImages, sigma_0,s);

Boxes_Orient = DrawBoxesOrient(Keypoints_Oriented,Image);
%pause;

% Get Descriptors
Descript = DescriptorsColour(Keypoints_Oriented,Magnitude,Orientations);
end
