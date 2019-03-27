bike = imread(strcat(pwd,'\dataset\Training\png\002-bike.png'));
%test = imread(strcat(pwd,'\dataset\Test\test_1.png'));
%peppers = imread('peppers.png');
Im1 = bike;
% Ver
%f = [-1, 1]';
% Hor
f=[-1,1];
% Gauss
N = 0;
%sigma = 20;
%sigma = 5; 
%f = GaussianBlurMatrix(N,sigma);

Im = zeros(size(Im1));
Im_mat = Im;
n = zeros(1,3);
for i=1:3
    Im_mat(:,:,i) = conv2(Im1(:,:,i),f,'same');
    Im(:,:,i) = Convolution(Im1(:,:,i),f);
    n(i) = norm(Im_mat(:,:,i)-Im(:,:,i))./norm(Im_mat(:,:,i));
end
disp(mean(n))
div = 300;
subplot(1,2,1);
imshow(Im./div);
title('Our Implementation')
subplot(1,2,2);
imshow(Im_mat./div);
title('Matlab')

%FileNameString = strcat(pwd,'/ConvolutionPictures/Gauss_',num2str(sigma));
%FileNameString = strcat(pwd,'/ConvolutionPictures/Vertical');
%print('-noui',FileNameString,'-djpeg')