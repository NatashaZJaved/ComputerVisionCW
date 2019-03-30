
r=1;

for count = 1:21
    clear Matches_SSDs;
    for the_match = 1:size(Matches_Cut{count,r},1)
        Matches_SSDs(the_match) = str2num(Matches_Cut{count,r}(the_match,2));
    end
    
    %disp(Matches_SSDs);
    threshold = 0;
    Larger_Than_thresh = find(Matches_SSDs > threshold);
    High_Thresh_Matches = Matches_Cut{count,r}(Larger_Than_thresh,:);
    
    disp(High_Thresh_Matches)
    
    new_im = insertShape(test_image,'Line',Line_Mat_Cut{count,r}(Larger_Than_thresh,:));
    imshow(new_im);
    pause;
end