Directory = 'C:\Users\Natasha\Desktop\CurrentModules\ComputerVision\dataset\dataset\Training\png\';
Files = dir(strcat(Directory,'*.png'));
for k = 1:length(Files)
    % Read images
    Im = imread(strcat(Directory,Files(k).name));
    Im = im2double(Im);
    % Set background to zero
    Im(Im<1e-8) = 0;
    % Normalise
    for i=1:3
        Im(:,:,i) = (Im(:,:,i) - mean2(Im(:,:,i)));
        Im(:,:,i) = Im(:,:,i)/norm(Im(:,:,i));
    end
%    Im = NormaliseImage(Im);
    imagesc(Im);
    pause;
    imwrite(Im,strcat('NormaliseImages/Train/',Files(k).name));
end