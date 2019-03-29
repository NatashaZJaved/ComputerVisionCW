function best_Match = CheckForBestestColoursNew(Match,Im_Descript)
% We has Match and Count

% Match is a cell array
% Match{pic}{blurs,scale}(i,:) is ith match where i is index of match in
% object pic and ssd


% We get rid of scales here
best_Match = cell(size(Im_Descript,1),...
    3, length(Match));

% Loop over blur and scale

for scale = 1:size(Im_Descript,1)
    for col = 1:3
        
        for picture = 1:length(Match)
            best_Match{scale,col,picture} = sparse(size(Im_Descript{scale,col},1),5);
        end
        
        % Look over each keypoint of the test_image
        for image_point = 1:size(Im_Descript{scale,col},1)
            % Check which is best for each pic
            best_pic = 0; min_ssd = inf;
            for pic = 1:size(Match,1)
                %Match{pic}{blurs,scale}(Match{pic}{blurs,scale} == 0) = inf;
                if (Match{pic}{scale,col}(image_point,5) < min_ssd) &&...
                        (Match{pic}{scale,col}(image_point,5)>0)
                    % This better, saves it
                    best_pic = pic; min_ssd = Match{pic}{scale,col}(image_point,5);
                end
            end
            if (best_pic > 0)
                % Store the picture it came from
                % The coordinates in that picture
                % And the ssd at that point
                best_Match{scale,col,best_pic}(image_point,:) =...
                    Match{best_pic}{scale,col}(image_point,:);
            end
        end
    end
end


end
