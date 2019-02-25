%bike = imread(strcat(pwd,'\dataset\Training\png\002-bike.png'));
%test = imread(strcat(pwd,'\dataset\Test\test_1.png'));
peppers = imread('peppers.png');
Im1 = peppers;
%f = [-1 1]';
f = [2 0 -2; 0 0 0; -3 0 3];
%f = padarray(f,[1 1]);
%f = eye(2); f(2,2) = -1;
Im = zeros(size(Im1));
Im_mat = Im;
n = zeros(1,3);
for i=1:3
    Im(:,:,i) = Convolution(Im1(:,:,i),f);
    Im_mat(:,:,i) = conv2(Im1(:,:,i),f,'same');
    n(i) = norm(Im_mat(:,:,i))/norm(Im(:,:,i));
end

figure;
imshow(Im,[]);
title('mine')
figure;
imshow(Im_mat,[]);
title('Matlab')