% We has Match and Count

% Match is a cell array
% Match{pic}{blurs,scale}(i,:) is ith match where i is index of match in
% object pic and ssd

best_Match = cell(size(Im_Descript));  

% Loop over blur and scale
for blurs = 1:size(Im_Descript,1)
    for scale = 1:size(Im_Descript,2)
        best_Match{blurs,scale} = NaN(size(Im_Descript{blurs,scale},1),4);
        % Look over each keypoint of the test_image
        for image_point = 1:size(Im_Descript{blurs,scale},1)
            % Check which is best for each pic
            best_pic = 0; min_ssd = inf;
            for pic = 1:size(Match,1)
                %Match{pic}{blurs,scale}(Match{pic}{blurs,scale} == 0) = inf;
                if Match{pic}{blurs,scale}(image_point,3) < min_ssd
                    % This better, saves it
                    best_pic = pic; min_ssd = Match{pic}{blurs,scale}(image_point,3);
                end
            end
            if (best_pic > 0)
                % Store the picture it came from
                % The coordinates in that picture
                % And the ssd at that point
                best_Match{blurs,scale}(image_point,:) =...
                    [best_pic,Match{best_pic}{blurs,scale}(image_point,1),...
                    Match{best_pic}{blurs,scale}(image_point,2),min_ssd];
            end
        end
    end
end
