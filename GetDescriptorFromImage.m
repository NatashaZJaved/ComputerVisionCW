function [Descript,Keypoints_Oriented] = GetDescriptorFromImage(Image)

sigma_0 = 0.5; s = 3; n_subscales = 4; 

% Get the Lowes
[Lowes,BlurredImages] = LowesPyramid(Image,sigma_0,s,n_subscales);

% Get them points
ThemPoints = Get_Keypoints(Lowes);

% Draw 
Drawing_Original_Points = DrawKeypoints(ThemPoints, Image);

% Filter w/ Taylor
ReducedKeypoints = FilterWithTaylor(ThemPoints,Lowes,sigma_0,s);

% Draw Taylored
Drawing_Taylored = DrawKeypoints(ReducedKeypoints, Image);

% Filter w/ Hessian
ReducedReducedKeypoints = FilterWithHessian(ReducedKeypoints,Lowes,sigma_0,s);

% Draw Taylored
Drawing_Proper_Reduced = DrawKeypoints(ReducedReducedKeypoints, Image);

% Draw Boxes
Boxes = DrawBoxes(ReducedReducedKeypoints, Image);

% Orient
[Keypoints_Oriented,Magnitude,Orientations]...
    = AssignOrientations(ReducedReducedKeypoints, BlurredImages, sigma_0,s);

% Draw Boxes
Boxes_Orient = DrawBoxesOrient(Keypoints_Oriented, Image);

% Get Descriptors
Descript = Descriptors(Keypoints_Oriented,Magnitude,Orientations);

figure; imshow([Drawing_Original_Points,Drawing_Taylored,Drawing_Proper_Reduced]);
figure; imshow(Boxes);
figure; imshow(Boxes_Orient);

end
