range = [2,3,4,8,12,16]';
% sigma_0 = 2;
% G = cell(length(range),1);
% for ind=1:length(range)
%     i = range(ind);
%     sigma = sigma_0*2^((i-2)/3);n=0;
%     G{i} = GaussianBlurMatrix(n,sigma);
% end
% Templates;

test_image = imread(strcat(pwd,'\dataset\Test\test_2.png'));


Actual_Thresholds = zeros(size(range));
%Initial_Thresholds = Actual_Thresholds;

Actual_Thresholds(2) = 110;
Actual_Thresholds(3) = 80;
Actual_Thresholds(4) = 60;
%Thresholds(6) = 50;
Actual_Thresholds(8) = 30;
Actual_Thresholds(12) = 29;
Actual_Thresholds(16) = 27;

Initial_Thresholds = Actual_Thresholds - 5;
% Initial_Thresholds(2) = 95;
% Initial_Thresholds(3) = 70;
% Initial_Thresholds(4) = 50;
% %Thresholds(6) = 50;
% Initial_Thresholds(8) = 45;
% Initial_Thresholds(12) = 35;
% Initial_Thresholds(16) = 29;

tic;
[Matches,Line_Mat] = intensity_based_matching(test_image,Initial_Thresholds,Actual_Thresholds);
toc;