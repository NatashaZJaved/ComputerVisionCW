% LOOP OVER RANGES AND THRESHOLDS
test_image = imread(strcat(pwd,'\dataset\Test\test_1.png'));

n_ranges = 4;
% Store Matches and boxes
%Matches = cell(400,n_ranges);
%Line_Mat = Matches;

% Make up some ranges
range_list = cell(2,1);
range_list{1} = [3,4,6,8,10,12,16]';
range_list{2} = [2,4,8,16]';
range_list{3} = [2,3,4,5,6,7,8,9]';
range_list{4} = [2,4,6,8,10,12,14,16]';

sigma_0 = 1;
count_list = [];
%count = 0;
count = 60;
for r = 3:length(range_list)
    range = range_list{r};
    % Set up some templates
    if (r>1 && r~=3)
        G = cell(length(range),1);
        for ind=1:length(range)
            i = range(ind);
            sigma = sigma_0*2^((i-2)/3);n=0;
            G{i} = GaussianBlurMatrix(n,sigma);
        end
        Templates;
        
        if (r~=3)
            % Test different thresholds
            
            % Simple Thresholds
            %Poss = linspace(0.02,0.05,15);
            Poss = 0.02;
            for i = 1:length(Poss)
                Thresholds = Poss(i)*ones(range(end),1);
                count = count+1;
                [Matches{count,r},Line_Mat{count,r}] = intensity_based_matching(test_image,Thresholds);
            end
            
            
            
            % Less simple thresholds
            Poss = linspace(0.02,0.035,10);
            Max = 0.055;
            for j = 1:10
                % Set min thresh
                Thresholds(1) = Poss(j);
                % Set max thresh
                Thresholds(end) = Max;
                Step = (Thresholds(end)-Thresholds(1))/max(range);
                for threrhhr = 2:(length(range)-1)
                    Thresholds(range(threrhhr)) = Thresholds(1) + Step.*range(threrhhr);
                end
                count = count + 1;
                [Matches{count,r},Line_Mat{count,r}] = intensity_based_matching(test_image,Thresholds);
            end
        end
    end
    
    % Higher max thresholds
    Poss = linspace(0.02,0.035,10);
    Max = 0.07;
    j_scale = 1:10;
    if (r ==1)
        j_scale = 3:10;
    elseif(r==3)
        j_scale = 4:10;
    end
    
    for j = j_scale
        % Set min thresh
        Thresholds(1) = Poss(j);
        % Set max thresh
        Thresholds(end) = Max;
        Step = (Thresholds(end)-Thresholds(1))/max(range);
        for threrhhr = 2:(length(range)-1)
            Thresholds(range(threrhhr)) = Thresholds(1) + Step.*range(threrhhr);
        end
        count = count + 1;
        [Matches{count,r},Line_Mat{count,r}] = intensity_based_matching(test_image,Thresholds);
    end
    
    count_list(r) = count;
end
