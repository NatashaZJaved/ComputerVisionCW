function selected = ibm_non_max_sup(corners, corr, overlap, area)
selected=[];
if ~isempty(corners)
    x_coords_1 = corners(:,1);
    x_coords_2 = corners(:,2);
    y_coords_1 = corners(:,3);
    y_coords_2 = corners(:,4);    
    
    [~, I] = sort(corr, 'descend');
    while ~isempty(I)
        i = I(1);
        selected = [selected; i]; %always pick the one of highest correlation
        remove = 1;
        for pos = 2:length(I)
            j = I(pos);
            overlap_x_1 = max(x_coords_1(i), x_coords_1(j));
            overlap_x_2 = min(x_coords_2(i), x_coords_2(j));
            overlap_y_1 = max(y_coords_1(i), y_coords_1(j));
            overlap_y_2 = min(y_coords_2(i), y_coords_2(j));
            width = overlap_x_2-overlap_x_1+1;
            height = overlap_y_2-overlap_y_1+1;
            if width > 0 && height > 0
                % compute overlap
                min_area = min(area(j),area(i));
                curr_over = width * height/min_area;
                if curr_over > overlap
                    remove = [remove; pos];
                end
            end
        end
        I(remove) = [];
    end
end
