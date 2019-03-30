range = [2,4,6,8,12,16]';

G = cell(length(range),1);
for ind=1:length(range)
    i = range(ind);
    sigma = sigma_0*2^((i-2)/3);n=0;
    G{i} = GaussianBlurMatrix(n,sigma);
end
Templates;

test_image = imread(strcat(pwd,'\dataset\Test\test_7.png'));

sigma_0 = 1;
Thresholds = zeros(size(range));

Thresholds(2) = 90;
Thresholds(3) = 70;
Thresholds(4) = 60;
Thresholds(6) = 50;
Thresholds(8) = 30;
Thresholds(12) = 20;
Thresholds(16) = 10;

tic;
[Matches,Line_Mat] = intensity_based_matching(test_image,Thresholds);
toc;